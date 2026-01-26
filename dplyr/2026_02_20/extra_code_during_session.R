library(dpylr)

# mtcars is an example data set that comes installed with R
# (we can simply start accessing it, no need to load it)
names(mtcars)
mtcars



mtcars %>% select(mpg, wt) %>% arrange(mpg, wt)
mtcars %>% select(mpg, wt) %>% arrange(desc(mpg))
cyl == 6
mtcars$cyl == 6

# creating a matrix with cbind() -- combining variables/vectors as columns
cbind(mtcars$cyl)

cbind(mtcars$cyl, mtcars$cyl = 6)  # what is going on here? why the error msg

cbind(mtcars$cyl, mtcars$cyl == 6)
mtcars$cyl == 6
x <- cbind(mtcars$cyl, mtcars$cyl == 6)
x

# why does the second column of x have 0 & 1 (and not FALSE/TRUE)?

# hint: is.matrix(x)

# another hint: what if we force R to print TRUE/FALSE)?
as.character(mtcars$cyl == 6)
cbind(mtcars$cyl, as.character(mtcars$cyl == 6)) # did this "work"?
"6" + 3
# remember (from Intro to R) that we are building a matrix and all columns
# in a matrix have to have the same data type!
is.matrix(x)

# the TRUE/FALSE data type is called a logical and is a bit special
is.logical(mtcars$cyl == 6)
# logicals can also function as numeric type, where TRUE == 1 & FALSE == 0
cbind(mtcars$cyl, mtcars$cyl == 6)


mtcars$cyl == 6
# so what does the following line tell us?
sum(mtcars$cyl == 6)



# this is a technique I use all the time t
cbind(mtcars$cyl, mtcars$cyl == 6)
# not very informative for the simple example (above), but it is a useful
# sanity check when with compound conditions, or needing to multiple variables
# at the same time
cbind(mtcars$cyl, mtcars$cyl == 6 & mtcars$wt < 20 & !is.na(mtcars$hp))
cbind(mtcars$cyl, mtcars$cyl == 6 & mtcars$wt < 20 & !is.na(mtcars$hp))

# a & b - means both sides have to be TRUE for the return value to be TRUE
# a | b - means only one side has to be TRUE for the return value to be TRUE
# note: sometimes it is good to use () for readability and makes sure the order of
# operations is satisfied
(6 < 10) & (6 < 6)
(6 < 10) | (6 < 6)

# another useful piece of syntax is ! which gives the opposite of a logical
TRUE
!TRUE
# (again, sometimes you need to use ())
cbind(mtcars$cyl, mtcars$wt, mtcars$hp, mtcars$cyl == 6 & mtcars$wt < 20 & !is.na(mtcars$hp))

mtcars$cyl == 6
!(mtcars$cyl == 6)
cbind(mtcars$cyl, mtcars$cyl == 6, !(mtcars$cyl == 6))
x <- mtcars$cyl
x
x[c(2, 5, 9)] <- NA
x
is.na(x)
!is.na(x)
cbind(x, is.na(x), !is.na(x))


# Homework: do this with dplyr tools only??
cbind(mtcars$cyl, mtcars$wt, mtcars$hp, mtcars$cyl == 6 & mtcars$wt < 20 & !is.na(mtcars$hp))


# another pipe (similar to %>%) that is slightly different
mtcars |>
  filter(cyl > 6)

# don't forget to save object if you want to work with it later
new_cars <- mtcars %>% 
  select(mpg, cyl) %>%
  mutate(mpg2 = mpg/1000)

new_cars


# need to be careful with missing data

mtcars$cyl[c(2, 4, 6)] <- NA
mtcars$cyl

# rows are excluded when filter condition has missing value
# (no error/warning message though!)
NA > 6
mtcars %>%
  filter(cyl < 6 | cyl > 7)
