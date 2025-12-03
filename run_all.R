# run_all.R
# Master script to run complete CoDA analysis pipeline

cat("==============================================\n")
cat("24-HOUR MOVEMENT BEHAVIOUR CoDA ANALYSIS\n")
cat("==============================================\n\n")

# Check working directory
if (!file.exists("coda_analysis.R")) {
  stop("\n✗ ERROR: Please set working directory to the r-shiny project root.\n",
       "  Use setwd('path/to/r-shiny') or open the project in RStudio.\n",
       "  Current directory: ", getwd())
}

# Define required packages
required_packages <- c(
  "compositions",
  "robCompositions",
  "tidyverse",
  "boot",
  "ggplot2"
)

optional_packages <- c("ggtern")

# Check and install required packages
cat("Checking required packages...\n")
missing_required <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if (length(missing_required) > 0) {
  cat("Installing missing required packages:", paste(missing_required, collapse = ", "), "\n")
  install.packages(missing_required, dependencies = TRUE)
}

# Try to install optional packages
missing_optional <- optional_packages[!(optional_packages %in% installed.packages()[,"Package"])]

if (length(missing_optional) > 0) {
  cat("Attempting to install optional packages:", paste(missing_optional, collapse = ", "), "\n")
  for (pkg in missing_optional) {
    tryCatch({
      install.packages(pkg, dependencies = TRUE)
      cat("✓", pkg, "installed\n")
    }, error = function(e) {
      warning("Optional package '", pkg, "' failed to install. Some plots may be skipped.", 
              call. = FALSE)
    })
  }
}

# Load packages
cat("Loading packages...\n")
for (pkg in c(required_packages, optional_packages)) {
  suppressPackageStartupMessages(
    library(pkg, character.only = TRUE, quietly = TRUE)
  )
}
cat("✓ Packages loaded\n\n")

cat("==============================================\n")
cat("PIPELINE EXECUTION\n")
cat("==============================================\n\n")

# Track execution time
start_time <- Sys.time()

# Step 1: Generate example data
cat("Step 1: Generating example data...\n")
tryCatch({
  source("data/generate_example_data.R")
  cat("✓ Data generation complete\n\n")
}, error = function(e) {
  stop("✗ Data generation failed: ", e$message)
})

# Step 2: Run compositional analysis
cat("Step 2: Running compositional data analysis...\n")
tryCatch({
  source("coda_analysis.R")
  cat("✓ Analysis complete\n\n")
}, error = function(e) {
  stop("✗ Analysis failed: ", e$message)
})

# Step 3: Create visualizations
cat("Step 3: Creating visualisations...\n")

plots_to_run <- c(
  "plots/plot_logratio_barplot.R",
  "plots/plot_percent_difference.R",
  "plots/plot_ternary.R",
  "plots/plot_compositional_alternative.R"
)

plots_succeeded <- 0
plots_failed <- 0

for (plot_script in plots_to_run) {
  tryCatch({
    source(plot_script)
    plots_succeeded <- plots_succeeded + 1
  }, error = function(e) {
    warning("Plot script failed: ", basename(plot_script), "\n  Error: ", e$message, 
            call. = FALSE)
    plots_failed <- plots_failed + 1
  })
}

cat("\n✓", plots_succeeded, "plots succeeded")
if (plots_failed > 0) {
  cat(", ", plots_failed, " plots failed or skipped")
}
cat("\n\n")

# Calculate execution time
end_time <- Sys.time()
execution_time <- difftime(end_time, start_time, units = "secs")

# Final summary
cat("==============================================\n")
cat("✓ PIPELINE COMPLETE\n")
cat("==============================================\n")
cat("Execution time:", round(execution_time, 2), "seconds\n")
cat("Figures saved in: figures/\n")
cat("Results saved in: results/\n\n")

# Session info for reproducibility
cat("Saving session info for reproducibility...\n")
if (!dir.exists("results")) dir.create("results")
writeLines(capture.output(sessionInfo()), "results/session_info.txt")
cat("✓ Session info saved to results/session_info.txt\n")
