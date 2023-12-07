#-----------------------------------------------------------------------------#
# run_all.R                                                                   #
#                                                                             #
#  Running this file will reproduce all the steps in the analysis.            #
#                                                                             #
#  created: 2023/08/15 -jt                                                    #
#  last modified: 2023/12/06  -jt                                             #
#                                                                             #
#-----------------------------------------------------------------------------#

# Set the working directory
# (note: windows needs two back slashes for paths)

getwd()                                      ## print the current working directory
setwd("C:\\Users\\jthomas\\Project Folder")  ## set the current working directory
dir()                                        ## print the contents of the wd

# All of the subsequent files will assume the working directory is
#
# "C:\\Users\\jthomas\\Project Folder"
# 
# so if you want data_prep.R to load the data file 
#
# "C:\\Users\\jthomas\\Project Folder\\original data\\dhs_zambia.csv"
#
# then your R code would be something like
#
# zambia <- read.csv("original data\\dhs_zambia.csv")
#
# and (for example) save the output with
#
# save(zambia_clean, "new data\\cleaned_zambia.RData")


# Step 1: data_prep.R -- prepare and clean data
# data_prep.R requires (1) file X, (2) file Y, (3) file Z
# data_prep.R creates (1) Data/clean_data.RData
date()
cat("Running data_prep.R")
source("R Code\\data_prep.R")                ## source("file.R") will run all the
                                             ## code in file.R

# Step 2: fit_models.R  -- run and save 5 regression models to "Results\\regresions.RData"
date()
cat("Running fit_models.R")
source("R Code\\fit_models.R")

# Step 3: create_tables.R -- create tables as CSV files in "Tables\\tab_XX.csv"
date()
cat("Running make_tables.R")
source("R Code\\make_tables.R")

# Step 4: create_figures.R -- create tables as PDF files in "Figures\\fig_XX.pdf"
date()
cat("Running make_figures.R")
source("R Code\\make_figures.R")


# --------  THE FOLLOWING STEPS ARE FOR THE R&R FROM SUBMISSION ON 2023/12/01 ------- #

# Step 5: revision1_data_prep.R -- create new data file with new variables coded using
#         suggestions of reviewers
date()
cat("Running revision1_data_prep.R")
source("R Code\\revision1_data_prep.R")    ## use a different folder here?
                                           ## might have multiple R&Rs or submissions!

# Step 6:
source("blah.R")

# Step 7:
source("more_blah.R")

