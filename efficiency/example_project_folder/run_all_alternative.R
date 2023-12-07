#-----------------------------------------------------------------------------#
# run_all_alternative.R                                                       #
#                                                                             #
#  Running this file will reproduce all the steps in the analysis.            #
#                                                                             #
#  created: 2023/08/15 -jt                                                    #
#  last modified: 2023/12/06  -jt                                             #
#                                                                             #
#-----------------------------------------------------------------------------#

# This version will run the R scripts in batch mode, and will save 



# Step 1:
system2(command="R", args = c("CMD", "BATCH", "--no-save",
                              "R Code\data_prep.R",
                              "R Code\data_prep.Rout"))
