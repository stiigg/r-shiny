# plots/plot_percent_difference.R
library(ggplot2)
library(tidyverse)

# Verify required input file exists
if (!file.exists("results/logratio_ci.rds")) {
  stop("Error: results/logratio_ci.rds not found. Run coda_analysis.R first.")
}

ci_df <- readRDS("results/logratio_ci.rds")

ci_df <- ci_df %>%
  mutate(
    percent_diff = 100 * (exp(log_ratio) - 1),
    percent_ci_lower = 100 * (exp(ci_lower) - 1),
    percent_ci_upper = 100 * (exp(ci_upper) - 1)
  )

p2 <- ggplot(ci_df, aes(x = behaviour, y = percent_diff)) +
  geom_point(size = 3, color = "darkred") +
  geom_errorbar(
    aes(ymin = percent_ci_lower, ymax = percent_ci_upper),
    width = 0.2,
    linewidth = 0.8,
    color = "darkred"
  ) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray30") +
  coord_flip() +
  labs(
    title = "Percent difference in behaviour composition: Boys vs Girls",
    subtitle = "Bootstrap 95% confidence intervals (2000 replicates)",
    x = "",
    y = "Percent difference (%)",
    caption = "Positive = higher in Boys; Negative = higher in Girls"
  ) +
  scale_x_discrete(labels = c("MVPA", "LPA", "Sedentary", "Sleep")) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 13),
    axis.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank()
  )

if (!dir.exists("figures")) {
  dir.create("figures", recursive = TRUE)
}

ggsave("figures/percent_difference_plot.png", p2, width = 7, height = 5, dpi = 300)
cat("✓ Percent-difference plot saved to figures/percent_difference_plot.png\n")
