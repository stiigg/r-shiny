# Generate synthetic 24-hour movement behaviour data
library(compositions)
set.seed(42)

# Generate synthetic data for 100 women and 100 men
n_per_group <- 100

# Women: slightly more sleep, less MVPA
women <- data.frame(
  id = 1:n_per_group,
  group = "Women",
  sleep = rnorm(n_per_group, mean = 520, sd = 45),
  sedentary = rnorm(n_per_group, mean = 660, sd = 50),
  lpa = rnorm(n_per_group, mean = 220, sd = 30),
  mvpa = rnorm(n_per_group, mean = 40, sd = 12)
)

# Men: less sleep, more MVPA
men <- data.frame(
  id = (n_per_group + 1):(2 * n_per_group),
  group = "Men",
  sleep = rnorm(n_per_group, mean = 490, sd = 45),
  sedentary = rnorm(n_per_group, mean = 670, sd = 50),
  lpa = rnorm(n_per_group, mean = 215, sd = 30),
  mvpa = rnorm(n_per_group, mean = 65, sd = 15)
)

# Combine and closure to 1440 minutes
movement_data <- rbind(women, men)
movement_data$total <- movement_data$sleep + movement_data$sedentary + movement_data$lpa + movement_data$mvpa
movement_data[, c("sleep", "sedentary", "lpa", "mvpa")] <-
  1440 * movement_data[, c("sleep", "sedentary", "lpa", "mvpa")] / movement_data$total

# Save
write.csv(movement_data, "data/example_movement_data.csv", row.names = FALSE)
cat("✓ Example dataset saved to data/example_movement_data.csv\n")
