#### ---- generate_data
x <- rnorm(100)
summary(x)
y <- 2.3 * x + rnorm(100)
summary(y)


#### ---- model_1
summary(lm(y ~ x))

