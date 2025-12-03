# Compositional Data Analysis: 24-Hour Movement Behaviours

Demonstration of publication-ready visualisation for 24-hour movement behaviour data using compositional data analysis (CoDA) in R.

## Overview
This repository contains R code to:
- Perform isometric log-ratio (ILR) transformations on 24-h movement data
- Compute geometric means and compositional differences between groups
- Generate bar plots of log-ratio differences with bootstrap confidence intervals
- Create percent-difference plots for isotemporal substitution analysis

## Key Features
- **Compositional data analysis**: Proper handling of constrained time-use data (sleep, sedentary, LPA, MVPA)
- **Bootstrap inference**: Percentile confidence intervals for group differences
- **Publication-ready figures**: ggplot2-based plots matching academic standards

## Requirements
```
install.packages(c("compositions", "robCompositions", "tidyverse", "boot", "ggplot2"))
```

## Quick Start
```
source("coda_analysis.R")
```

## Methods
Based on sequential binary partitioning and ILR coordinates as described in Dumuid et al. (2018, 2019) and recent 24-h movement behaviour literature.

## References
- Dumuid et al. (2018). Compositional data analysis for physical activity, sedentary time and sleep research. *Statistical Methods in Medical Research*.
- Suorsa et al. (2022). Changes in the 24-h movement behaviors during the transition to retirement. *Int J Behav Nutr Phys Act*.
