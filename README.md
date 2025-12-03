# Compositional Data Analysis: 24-Hour Movement Behaviours

Demonstration of publication-ready visualisation for 24-hour movement behaviour data using compositional data analysis (CoDA) in R.

## Overview
This repository contains R code to:
- Perform isometric log-ratio (ILR) transformations on 24-h movement data
- Compute geometric means and compositional differences between groups
- Generate bar plots of log-ratio differences with bootstrap confidence intervals
- Create percent-difference plots for isotemporal substitution analysis

## Installation

### Required Packages
```
install.packages(c(
  "compositions",
  "robCompositions", 
  "tidyverse",
  "boot",
  "ggplot2"
))
```

### Optional Packages
```
# For ternary plots (may have installation issues on some systems)
install.packages("ggtern")
```

**Note:** If `ggtern` fails to install, the pipeline will still run successfully but will skip ternary plot generation. This is expected behavior.

### System Requirements
- R >= 3.5.0 (recommended: >= 4.0.0)
- Linux users may need: `sudo apt-get install libgsl-dev`

## Key Features
- **Compositional data analysis**: Proper handling of constrained time-use data (sleep, sedentary, LPA, MVPA)
- **Bootstrap inference**: Percentile confidence intervals for group differences
- **Publication-ready figures**: ggplot2-based plots matching academic standards

## Quick Start
```
source("coda_analysis.R")
```

## Methods
Based on sequential binary partitioning and ILR coordinates as described in Dumuid et al. (2018, 2019) and recent 24-h movement behaviour literature.

## References
- Dumuid et al. (2018). Compositional data analysis for physical activity, sedentary time and sleep research. *Statistical Methods in Medical Research*.
- Suorsa et al. (2022). Changes in the 24-h movement behaviors during the transition to retirement. *Int J Behav Nutr Phys Act*.

## Troubleshooting

### Common Issues

**Problem:** `install.packages("ggtern")` fails  
**Solution:** ggtern is optional. The pipeline will run without it, skipping only the ternary plot. Alternative: Use the 2D compositional scatter plot instead.

**Problem:** "object 'coord_transform.cartesian' not found"  
**Solution:** This is a known ggtern/ggplot2 compatibility issue. Try:
```
remove.packages("ggtern")
install.packages("ggplot2", version = "3.3.6")
install.packages("ggtern")
```

**Problem:** "working directory" or "file not found" errors  
**Solution:** Ensure you're running from project root:
```
# Check current directory
getwd()

# Set to project root
setwd("path/to/r-shiny")

# Or open r-shiny.Rproj in RStudio
```

**Problem:** Package installation fails on Linux  
**Solution:** Install system dependencies:
```
sudo apt-get update
sudo apt-get install libgsl-dev r-base-dev
```

### Getting Help

If issues persist:
1. Check `results/session_info.txt` for your package versions
2. Ensure R version >= 3.5.0 (check with `R.version.string`)
3. Try running `source("run_all.R")` from a fresh R session
