library(survey)
library(dplyr)

# load data
data(api)
ls()
names(apipop)

# explore apipop
length(unique(apipop$name))
length(unique(apipop$dname))
length(unique(apipop$cname))
sum(apipop$api.stu)
sum(apipop$enroll, na.rm=TRUE)
table(apipop$stype)


#-----------------------------------------------------------------------------
# SRS Simulation
#-----------------------------------------------------------------------------

# Part I

## Can you draw a SRS of size n = 100?
samp1_prob <- NA

samp1_id <- sample(x = apipop$cds,      # or you could do this with rows
                   size = 100,
                   replace = FALSE,
                   prob = )

samp1 <- subset(apipop, cds %in% samp1_id)
dim(samp1)


## + how does the sample mean for `api99` compare to the population mean?
  
## Can you show that the SRS mean is *unbiased*?
  
##  + Create an empty matrix with 50 rows and 2 columns, then loop over the
##  rows.
sim_results <- matrix(1:100, nrow=50, ncol=2)

#### example of a loop
for (i in 1:50) {
  cat("Row ", i, "has values ",
      paste(sim_results[i, ], collapse = " & "),
      "\n")
}


#### example of nested loops
for (i in 1:nrow(sim_results)) {
  cat("Row ", i, "has values ")
  for (j in 1:2) {
    if (j == 1) {
      ## ????
    } else {
      ## ????
    }
  }
}


##  + Take a SRS of size 100, calculate the mean, and
##  store it in a vector called, `samp_means`.

##  + Repeat the previous step (M - 1) = (100 - 1) = 99 more times.
##  Store the mean of `samp_means` in the (first row, second col)
##  of you matrix.

## Fill in the rest of the matrix.  After you fill a row, increase
## the value of M by 100.


# Part II

## Note that we could conduct a similar exercise for the variance.

##  + What could we change about the simulation besides
##  the size of M?  What effect do you think this would have?
  
## How would you conduct an informative simulation for the
## confidence interval of the mean?
  
