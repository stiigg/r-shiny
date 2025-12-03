# Generate synthetic 24-hour movement behaviour data
library(compositions)
set.seed(42)

# Generate synthetic data for 100 girls and 100 boys
n_per_group <- 100

# Girls: slightly more sleep, less MVPA
girls <- data.frame(
  id = 1:n_per_group,
  group = "Girls",
  sleep = rnorm(n_per_group, mean = 520, sd = 45),
  sedentary = rnorm(n_per_group, mean = 660, sd = 50),
  lpa = rnorm(n_per_group, mean = 220, sd = 30),
  mvpa = rnorm(n_per_group, mean = 40, sd = 12)
)

# Boys: less sleep, more MVPA
boys <- data.frame(
  id = (n_per_group + 1):(2 * n_per_group),
  group = "Boys",
  sleep = rnorm(n_per_group, mean = 490, sd = 45),
  sedentary = rnorm(n_per_group, mean = 670, sd = 50),
  lpa = rnorm(n_per_group, mean = 215, sd = 30),
  mvpa = rnorm(n_per_group, mean = 65, sd = 15)
)

# Combine and closure to 1440 minutes
movement_data <- rbind(girls, boys)
movement_data$total <- movement_data$sleep + movement_data$sedentary + movement_data$lpa + movement_data$mvpa
movement_data[, c("sleep", "sedentary", "lpa", "mvpa")] <-
  1440 * movement_data[, c("sleep", "sedentary", "lpa", "mvpa")] / movement_data$total

# Save
write.csv(movement_data, "data/example_movement_data.csv", row.names = FALSE)
cat("✓ Example dataset saved to data/example_movement_data.csv\n")
