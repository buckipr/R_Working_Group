#-----------------------------------------------------------------------------#
# R Working Group (Mar 3rd, 2023) -- Introduction to ggplot2                  #
#                                                                             #
# ggplot2: Elegant Graphics for Data Analysis by Hadley Wickham               #
#                                                                             #
# "In brief, the grammar tells us that a statistical graphic is a mapping     #
# from data to aesthetic attributes (colour, shape, size) of geometric        #
# objects (points, lines, bars). The plot may also contain statistical        #
# transformations of the data and is drawn on a specific coordinate system.   #
# Faceting can be used to generate the same plot for different subsets of the #
# dataset. It is the combination of these independent components that make up #
# a graphic." (p.3)                                                           #
#                                                                             #
#-----------------------------------------------------------------------------#

# Grammar:

# 1) aes -- data and aesthetic mappings (data -> attributes on the plot)
# 2) geoms -- geometric objects (attributes that appear, e.g., lines or points)
# 3) stats -- statistical transformations of the data (e.g. regression lines)
# 4) scales -- another mapping of data -> aesthetic space, be it physical 
#              location (e.g. reverse order of values) or appearance
#              (e.g., color, aesthetic size, shape)
# 5) coord -- coordinate system
# 6) facet -- specification for producing a plot conditional on a variable,
#             e.g., make 3 plots of income vs. education for 3 different
#             racial groups (aka lattice/trellis)

library(ggplot2)
library(dplyr)
library(gridExtra)
data(mpg)
names(mpg)
head(mpg)

mpg <- mpg %>% rename(man = manufacturer)
names(mpg)

#-----------------------------------------------------------------------------#
# Basics
#-----------------------------------------------------------------------------#
## create canvas
ggplot(mpg)
# variables of interest mapped to x- & y-axis
ggplot(mpg, aes(x = displ, y = hwy))
# data plotted by adding a layer (each layer superimposed with "+" )
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()


#-----------------------------------------------------------------------------#
# Geoms
#-----------------------------------------------------------------------------#
## histogram
ggplot(data = mpg, mapping = aes(x = hwy)) +
  geom_histogram(binwidth = 5)

mpg %>% filter(man == "audi") %>%
  ggplot(aes(x=hwy)) + geom_histogram(binwidth = 1)

mpg %>% filter(man == "audi") %>%
  ggplot(aes(x=log(hwy))) + geom_histogram(binwidth = .01)

mpg %>%
  ggplot(aes(x=log(hwy))) + geom_histogram(binwidth = .01) +
  facet_wrap(vars(man))

## barplot
ggplot(mpg) + geom_bar(mapping = aes(x = man))

ggplot(mpg) + geom_bar(mapping = aes(x = man)) +
  coord_flip()

mpg %>%
  mutate(low_mpg = ifelse(cty < quantile(cty, .2), "yes", "no")) %>%
  ggplot() + geom_bar(aes(x=low_mpg), fill = "blue")


mpg2 <- mpg %>%
  mutate(low_mpg = ifelse(cty < quantile(cty, .2), "yes", "no"))


## geom: points
ggplot(mpg, aes(x=cty, y=hwy)) + geom_point()

ggplot(mpg, aes(x=cty, y=hwy)) + geom_point(aes(color = cyl))

ggplot(mpg, aes(x=cty, y=hwy)) + geom_point(aes(color = "red"))

ggplot(mpg, aes(x=cty, y=hwy)) + 
  geom_point(aes(color = cyl, shape = trans)) +
  labs(color = "Cylinder", shape = "Transmission")


ggplot(mpg, aes(x=cty, y=hwy)) + 
  geom_point(aes(size = desc(year)))

ggplot(mpg, aes(x=cty, y=hwy)) + 
  geom_point(aes(size = desc(year)), alpha = 1/10)


ggplot(mpg, aes(x=year, y=hwy)) + 
  geom_line(aes(group = model), linetype = "dotdash")

ggplot(mpg, aes(x=year, y=hwy)) + 
  geom_line(aes(linetype = model))

mpg %>% group_by(model) %>% mutate(mu_hwy = mean(hwy)) %>%
  ggplot(aes(x = year, y = mu_hwy)) +
    geom_line(aes(linetype = model))


ggplot(mpg) +
  geom_boxplot(aes(x = as.factor(cyl), y = cty)) +
  coord_flip()


data.frame(v1 = rnorm(1000)) %>%
  mutate(v2 = log(v1) + rnorm(1000)) %>%
  ggplot(aes(x = v1, y = v2)) + 
  geom_bin2d()


#-----------------------------------------------------------------------------#
# Regression results
#-----------------------------------------------------------------------------#s
g1 <- ggplot(mpg, aes(cty)) +
  geom_histogram(aes(y = after_stat(density)), color = "blue", fill = "white")
g1

g2 <- g1 + geom_density(alpha = .2, fill = "orchid") +
  geom_vline(xintercept = mean(mpg$cty))
g2


ggplot(mpg, aes(x = displ, y = cty)) +
  geom_point() + geom_smooth(se = FALSE) +
  labs(title = "Adding a loess smoother", x = "displacement?")

ggplot(mpg, aes(x = displ, y = cty)) +
  geom_point() + geom_smooth(span = .3) +
  labs(title = "Adding a wiggly loess smoother", x = "displacement?")


ggplot(mpg, aes(x = displ, y = cty)) +
  geom_point() + geom_smooth(method = lm) +
  labs(title = "Adding OLS", x = "displacement?")


ggplot(mpg, aes(x = displ, y = cty, color = as.factor(cyl))) +
  geom_point() + geom_smooth(method = lm) +
  labs(title = "Adding OLS", x = "displacement?")


ggplot(mpg, aes(x = displ, y = cty)) +
  geom_point() + geom_smooth(method = lm) +
  facet_wrap(~cyl) + 
  labs(title = "Adding OLS", x = "displacement?")


mod1 <- lm(cty ~ displ + as.factor(cyl), data = mpg)
summary(mod1)

fit1 <- predict(mod1, interval = "confidence", level = 0.90)
fit1
fit1.full <- cbind(mpg, fit1)


colnames(predict(mod1, interval = "confidence", level = 0.90))

ggplot(fit1.full, aes(x = displ, y = cty, color = as.factor(cyl))) +
         geom_point() + geom_line(aes(y = fit)) +
  geom_ribbon(aes(ymin = lwr, ymax = upr, fill = as.factor(cyl)), alpha = .2)

mod2 <- lm(cty ~ displ + as.factor(cyl) + year + as.factor(trans), data=mpg)
yhat <- predict(mod2)

p1 <- mpg %>%
  mutate(yhat = yhat) %>%
  ggplot(aes(x = displ, y = yhat)) + 
  geom_point(aes(color="y_hat", shape="y_hat"))
# suppress legend:
# mpg %>%
#   mutate(yhat = yhat) %>%
#   ggplot(aes(x = displ, y = yhat)) +
#   geom_point(aes(color="y_hat", shape="y_hat")) +
#   theme(legend.position = "none")
p1 + geom_point(data=mpg, aes(x=displ, y=cty, color="observed", shape="observed")) +
 guides(color=guide_legend(title="Points")) +
 theme(legend.position = c(.8, .8))
# consolidate to 1 legend
p1 + geom_point(data=mpg, aes(x=displ, y=cty, color="observed", shape="observed")) +
 guides(color=guide_legend(title="Legend"),
        shape = "none") +
  scale_color_manual(name="Legend", values=c("observed"="red", "y_hat"="black"))
  scale_shape_manual(name="Legend", values=c(1, 2)) +
 theme(legend.position = c(.8, .8), legend.title=element_blank())


## ggPredict
## https://cran.r-project.org/web/packages/ggiraphExtra/vignettes/ggPredict.html

## Saving multiple plots to one file
my_plots <- list()
my_plots[[1]] <- p1
my_plots[[2]] <- p1
ggsave(
  filename = "myplots.pdf", 
  plot = marrangeGrob(my_plots, nrow=1, ncol=1), 
  width = 15, height = 9
)

