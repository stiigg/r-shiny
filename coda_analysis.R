# coda_analysis.R
# Compositional Data Analysis for 24-hour Movement Behaviours
# Author: Christian Baghai
# Date: December 2025

# Load required packages
library(compositions)
library(robCompositions)
library(tidyverse)
library(boot)

# 1. LOAD DATA ----
data <- read.csv("data/example_movement_data.csv")

# 2. CREATE COMPOSITION ----
# Order: sleep, sedentary, lpa, mvpa
data$composition <- acomp(data[, c("sleep", "sedentary", "lpa", "mvpa")])

# 3. COMPUTE GEOMETRIC MEANS BY GROUP ----
geom_means <- data %>%
  group_by(group) %>%
  summarise(
    mean_comp = list(mean(composition)),
    .groups = "drop"
  )

# Extract geometric means in minutes
first_mean <- clo(geom_means$mean_comp[[1]], total = 1440)
second_mean <- clo(geom_means$mean_comp[[2]], total = 1440)

names(first_mean) <- c("sleep", "sedentary", "lpa", "mvpa")
names(second_mean) <- c("sleep", "sedentary", "lpa", "mvpa")

cat("\nGeometric means (minutes/day):\n")
cat(paste0(geom_means$group[1], ": ", paste(round(first_mean, 1), collapse = ", "), "\n"))
cat(paste0(geom_means$group[2], ": ", paste(round(second_mean, 1), collapse = ", "), "\n"))

# 4. COMPUTE LOG-RATIO DIFFERENCES ----
log_ratio_diff <- log(second_mean / first_mean)

cat("\nLog-ratio differences (", geom_means$group[2], " vs ", geom_means$group[1], "):\n", sep = "")
print(round(log_ratio_diff, 3))

# 5. SEQUENTIAL BINARY PARTITION FOR ILR ----
sbp <- matrix(c(
  1, 1, -1, -1,  # ilr1: active (LPA+MVPA) vs passive (sleep+SED)
  0, 0,  1, -1,  # ilr2: LPA vs MVPA
  1, -1,  0,  0  # ilr3: sleep vs SED
), ncol = 4, byrow = TRUE)

colnames(sbp) <- c("sleep", "sedentary", "lpa", "mvpa")
rownames(sbp) <- c("ilr1", "ilr2", "ilr3")

# Build ILR basis
psi <- gsi.buildilrBase(t(sbp))

# Transform to ILR coordinates
data$ilr_coords <- ilr(data$composition, V = psi)
data <- data %>%
  mutate(
    ilr1 = ilr_coords[, 1],
    ilr2 = ilr_coords[, 2],
    ilr3 = ilr_coords[, 3]
  )

# 6. BOOTSTRAP CONFIDENCE INTERVALS FOR LOG-RATIO DIFFERENCES ----
bootstrap_logratio <- function(data, indices, group1, group2) {
  d <- data[indices, ]
  g1_data <- d %>% filter(group == group1)
  g2_data <- d %>% filter(group == group2)

  g1_mean <- mean(acomp(g1_data[, c("sleep", "sedentary", "lpa", "mvpa")]))
  g2_mean <- mean(acomp(g2_data[, c("sleep", "sedentary", "lpa", "mvpa")]))

  g1_min <- clo(g1_mean, total = 1440)
  g2_min <- clo(g2_mean, total = 1440)

  return(log(g2_min / g1_min))
}

set.seed(123)
boot_results <- boot(
  data = data,
  statistic = bootstrap_logratio,
  R = 2000,
  group1 = geom_means$group[1],
  group2 = geom_means$group[2]
)

ci_logratio <- sapply(1:4, function(i) {
  boot.ci(boot_results, type = "perc", index = i)$percent[4:5]
})

ci_df <- data.frame(
  behaviour = c("sleep", "sedentary", "lpa", "mvpa"),
  log_ratio = log_ratio_diff,
  ci_lower = ci_logratio[1, ],
  ci_upper = ci_logratio[2, ]
)

print(ci_df)

if (!dir.exists("results")) {
  dir.create("results", recursive = TRUE)
}

saveRDS(ci_df, "results/logratio_ci.rds")
saveRDS(geom_means, "results/geom_means.rds")

cat("\n✓ Analysis complete. Results saved to results/ directory.\n")
