# Project on Cohort Analysis of Fertility Desires

This project looks at fertility desires and tries to assess changes across cohorts vs. changes with age.
Data from the Demographic Health Surveys (DHS) are used for the analyses.

## Producing Results

To produce the results, use R to run the file `Code/run_all.R`.  Details are listed [below](#analytic-steps).

The files/software/packages needed to produce the results are:

* R Version 4.3.1
* haven (version??)
* dplyr (version??)
* ggplot2 (version??)
* Data from the Zambian Demographic Health Surveys are used for the analysis
which can be obtained from the [DHS site](https://dhsprogram.com/publications/publication-fr361-dhs-final-reports.cfm)


## Folder Layout

<pre>
|-- Data
|   |- DHS
|   |  |- zambia_dhs_2007.RData
|   |  |- zambia_dhs_2011.RData
|   |
|   |- Cleaned
|   |  |- clean_zambia07.RData
|   |  |- clean_zambia11.RData
|   |  |- clean_zambia_all.RData
|
|-- Code
|   |- run_all.R
|   |- download_data.R
|   |- fit_models.R
|   |- make_tables.R
|   |- make_figures.R
|
|-- Figures
|
|-- Tables
</pre>

## Analytic Steps

The R script `Code/run_all.R` performs the following steps...

1. Download the data via the DHS API
   + this is done by sourcing the file `Code/download_data.R`
   + the data are stored in `Data/DHS` folder
   + **TODO**: still need to add code to download latest survey
1. Clean the data and prepare the variables needed for analysis
   + this is done by running the code in `Code/prepare_data.R
1. Run the models (by running `Code/run_models.R`)
1. Create tables (by running `Code/make_tables.R`)
   + *still need to do this!*
   + tables will be CSV files stored as `Tables/tab_X.csv`
1. Create figures (by running `Code/make_figures.R`)
   + *still need to do this!*
   + figures will be PDf files stored as `Figures/fig_X.pdf`
