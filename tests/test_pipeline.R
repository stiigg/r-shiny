# tests/test_pipeline.R
# Quick validation test before running full pipeline

cat("Testing pipeline components...\n\n")

# Test 1: File structure
cat("1. Checking files... ")
required_files <- c(
  "run_all.R",
  "coda_analysis.R",
  "data/generate_example_data.R",
  "plots/plot_logratio_barplot.R",
  "plots/plot_percent_difference.R",
  "plots/plot_ternary.R"
)

if (all(file.exists(required_files))) {
  cat("✓\n")
} else {
  cat("✗\n")
  cat("Missing:", required_files[!file.exists(required_files)], "\n")
}

# Test 2: Critical packages
cat("2. Checking packages... ")
critical <- c("compositions", "robCompositions", "tidyverse", "boot", "ggplot2")
if (all(sapply(critical, requireNamespace, quietly = TRUE))) {
  cat("✓\n")
} else {
  cat("✗\n")
  missing <- critical[!sapply(critical, requireNamespace, quietly = TRUE)]
  cat("Missing:", paste(missing, collapse = ", "), "\n")
  cat("Install with: install.packages(c('", paste(missing, collapse = "','"), "'))\n", sep = "")
}

# Test 3: Optional packages
cat("3. Checking optional... ")
if (requireNamespace("ggtern", quietly = TRUE)) {
  cat("✓ (ggtern available)\n")
} else {
  cat("⚠ (ggtern not installed - ternary plots will be skipped)\n")
}

cat("\nRun pipeline with: source('run_all.R')\n")
