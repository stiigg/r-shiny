# run_all.R
# Master script to run complete CoDA analysis pipeline

cat("==============================================\n")
cat("24-HOUR MOVEMENT BEHAVIOUR CoDA ANALYSIS\n")
cat("==============================================\n\n")

cat("Step 1: Generating example data...\n")
source("data/generate_example_data.R")

cat("\nStep 2: Running compositional data analysis...\n")
source("coda_analysis.R")

cat("\nStep 3: Creating visualisations...\n")
source("plots/plot_logratio_barplot.R")
source("plots/plot_percent_difference.R")
source("plots/plot_ternary.R")

cat("\n==============================================\n")
cat("✓ PIPELINE COMPLETE\n")
cat("==============================================\n")
cat("Figures saved in figures/ directory\n")
cat("Results saved in results/ directory\n")
