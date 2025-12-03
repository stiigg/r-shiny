# plots/plot_compositional_alternative.R
# Alternative to ternary plot (no ggtern required)

library(ggplot2)
library(tidyverse)

if (!file.exists("data/example_movement_data.csv")) {
  stop("Error: data/example_movement_data.csv not found.")
}

data <- read.csv("data/example_movement_data.csv")

# Calculate percentages
data <- data %>%
  mutate(
    active = lpa + mvpa,
    total = sleep + sedentary + active,
    sleep_pct = 100 * sleep / total,
    sed_pct = 100 * sedentary / total,
    active_pct = 100 * active / total
  )

# Create 2D compositional plot
p_comp <- ggplot(data, aes(x = sleep_pct, y = active_pct, color = group)) +
  geom_point(alpha = 0.6, size = 2.5) +
  stat_ellipse(level = 0.95, linetype = "dashed") +
  labs(
    title = "24-h movement behaviour composition",
    subtitle = "Sleep vs Active time (% of 24h) with 95% confidence ellipses",
    x = "Sleep (%)",
    y = "Active time: LPA+MVPA (%)",
    color = "Group"
  ) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  ) +
  scale_color_manual(values = c("#2E86AB", "#A23B72"))

if (!dir.exists("figures")) {
  dir.create("figures", recursive = TRUE)
}

ggsave("figures/compositional_2d_plot.png", p_comp, width = 7, height = 6, dpi = 300)
cat("✓ 2D compositional plot saved to figures/compositional_2d_plot.png\n")
