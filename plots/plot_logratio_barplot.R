# plots/plot_logratio_barplot.R
library(ggplot2)
library(tidyverse)

ci_df <- readRDS("results/logratio_ci.rds")

p1 <- ggplot(ci_df, aes(x = behaviour, y = log_ratio)) +
  geom_col(fill = "steelblue", alpha = 0.7, width = 0.6) +
  geom_errorbar(
    aes(ymin = ci_lower, ymax = ci_upper),
    width = 0.25,
    linewidth = 0.8
  ) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray30") +
  labs(
    title = "Log-ratio differences: Boys vs Girls",
    subtitle = "24-hour movement behaviours (n=200, bootstrap 95% CI)",
    x = "Behaviour",
    y = "Log-ratio difference",
    caption = "Positive values indicate higher proportion in Boys"
  ) +
  scale_x_discrete(labels = c("Sleep", "Sedentary", "LPA", "MVPA")) +
  theme_bw(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.title = element_text(face = "bold"),
    panel.grid.major.x = element_blank()
  )

if (!dir.exists("figures")) {
  dir.create("figures", recursive = TRUE)
}

ggsave("figures/logratio_barplot.png", p1, width = 7, height = 5, dpi = 300)
cat("✓ Bar plot saved to figures/logratio_barplot.png\n")
