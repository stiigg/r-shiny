# plots/plot_ternary.R
library(compositions)
library(tidyverse)

# Check if ggtern is available
ggtern_available <- requireNamespace("ggtern", quietly = TRUE)

if (!ggtern_available) {
  warning("ggtern package not available. Skipping ternary plot generation.\n",
          "Install with: install.packages('ggtern')")
  cat("⚠ Ternary plot skipped (ggtern not installed)\n")
  return(invisible(NULL))
}

# Only load ggtern if available
library(ggtern)

# Verify data file exists
if (!file.exists("data/example_movement_data.csv")) {
  stop("Error: data/example_movement_data.csv not found. Run data generation first.")
}

data <- read.csv("data/example_movement_data.csv")

data$active <- data$lpa + data$mvpa
tern_data <- data %>%
  mutate(
    sleep_prop = sleep / (sleep + sedentary + active),
    sed_prop = sedentary / (sleep + sedentary + active),
    active_prop = active / (sleep + sedentary + active)
  )

tryCatch({
  p_tern <- ggtern(tern_data, aes(x = sleep_prop, y = sed_prop, z = active_prop, color = group)) +
    geom_point(alpha = 0.5, size = 2) +
    labs(
      title = "24-h movement behaviour composition",
      x = "Sleep",
      y = "Sedentary",
      z = "Active (LPA+MVPA)"
    ) +
    theme_bw()

  if (!dir.exists("figures")) {
    dir.create("figures", recursive = TRUE)
  }

  ggsave("figures/ternary_plot.png", p_tern, width = 7, height = 6, dpi = 300)
  cat("✓ Ternary plot saved to figures/ternary_plot.png\n")
}, error = function(e) {
  warning("Failed to create ternary plot: ", e$message)
  cat("⚠ Ternary plot generation failed\n")
})
