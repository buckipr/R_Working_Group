#------------------------------------------------------------------------------#
# ggplot2_code.R
#
# code used in slides (NOT COMMENTED VERY WELL)
#
#------------------------------------------------------------------------------#

# Load libraries
library(knitr)
library(emoji)
library(tidyverse)
library(RColorBrewer)
library(DT)
library(viridis)
library(gridExtra)

data(mtcars)


# Layering in action
ggplot(data = mtcars)
ggplot(data = mtcars,
       mapping = aes(x = mpg, y = wt))
ggplot(data = mtcars,
       mapping = aes(x = mpg, y = wt)) + ## don't forget the '+' !!
  geom_point()



# Structure of a ggplot
p <- ggplot(mtcars, aes(x = mpg, y = wt, color=factor(cyl))) + 
  geom_point()
names(p)
summary(p)

# Global vs. Local
ggplot(mtcars, aes(x = mpg, y = wt, color=factor(cyl))) +
  geom_point() + geom_smooth(method="lm")

ggplot(mtcars, aes(x = mpg, y = wt)) +
  geom_point(aes(color = factor(cyl))) + geom_smooth(method="lm")


# A few more aesthetics
ggplot(mtcars, aes(x = mpg, y = wt,
                   color = factor(cyl),
                   shape = factor(cyl))) + 
  geom_point(size = 3)  

ggplot(mtcars, aes(x = mpg, y = wt,
                   color = factor(cyl),
                   shape = factor(cyl),
                   size = cyl)) + 
  geom_point()

ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) +
  geom_point() + 
  geom_hline(yintercept = mean(mtcars$wt),
             linewidth = 2) 

ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) +
  geom_point() + 
  geom_hline(yintercept = mean(mtcars$wt[mtcars$cyl == 4]), linetype = 1) + 
  geom_hline(yintercept = mean(mtcars$wt[mtcars$cyl == 6]), linetype = 2) + 
  geom_hline(yintercept = mean(mtcars$wt[mtcars$cyl == 8]), linetype = 3) 

## Biscuits!
ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) +
  geom_point() + 
  geom_hline(aes(yintercept = mean(wt), linetype = factor(cyl)))


# Thanks dplyr!!

df_mean_wt <- mtcars %>% group_by(cyl) %>% summarize(mean_wt = mean(wt))
ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) +
  geom_point() + 
  geom_hline(aes(yintercept = mean_wt, linetype = factor(cyl)), data = df_mean_wt)

# Exercise

df_mean_wt <- mtcars %>% group_by(cyl) %>% summarize(mean_wt = mean(wt))
ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) +
  geom_point() + 
  geom_hline(aes(yintercept = mean_wt, linetype = factor(cyl), color=factor(cyl)), data = df_mean_wt)


rando <- data.frame(x = runif(10), y = runif(10))
ggplot(rando, aes(x = x, y = y)) + geom_point() + 
  geom_abline(intercept = 0, slope = 1, linetype = 2) # another useful line

# Setting color: manually

ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point() +
  geom_vline(aes(xintercept = mean(mpg)),
             color = "red")  

ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + 
  geom_point() +
  scale_color_manual(values = c("green", "red", "blue")) 


# Setting color: grey scale

ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point() + 
  scale_color_grey(start = 0.0, end = 0.4) 

# Setting color: gradients

ggplot(mtcars, aes(x = mpg, y = wt, color = cyl)) + # cyl now continuous
  geom_point() + 
  scale_color_gradient(low="red", high="blue") 


# Setting color: color brewer

ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point() +
  scale_color_brewer(palette = "BuPu") 

# Setting color: Viridis


ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point() +
  scale_color_viridis(discrete = TRUE, option = "magma") 

# Tour of geoms: barchart

ggplot(mtcars, aes(x = cyl)) + 
  geom_bar() 

# Tour of geoms: barchar (ordered)

ggplot(mtcars, aes(x = fct_infreq(factor(cyl)))) +  # need tidyverse for this
  geom_bar()


# Tour of geoms: barchart (custom)
mtcars %>% mutate(cyl2 = factor(cyl, levels = c(6, 4, 8))) %>%
  ggplot(aes(x = cyl2)) + geom_bar()


# Tour of geoms: barchart
ggplot(mtcars, aes(x = cyl)) + 
  geom_bar(fill = c("blue", "pink4", "green")) 


# Tour of geoms: barchart
ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +  geom_bar() +
  scale_color_brewer(palette = "Pastel1") 

# Tour of geoms: boxplot
ggplot(mtcars, aes(x = factor(cyl), y = mpg, color = factor(cyl))) +
  geom_boxplot()

ggplot(mtcars, aes(x = factor(cyl), y = mpg, fill = factor(am))) +
  geom_boxplot()

# Tour of geoms: text
ggplot(mtcars, aes(x = wt, mpg,
                   label = rownames(mtcars))) + 
  geom_text() 

ggplot(mtcars, aes(x = wt, mpg, label = rownames(mtcars))) + geom_point() +
  geom_text(hjust = "right", nudge_x = -0.15)  


ggplot(mtcars, aes(x = wt, mpg, label = rownames(mtcars))) + geom_point() +
  geom_text(vjust = 0, nudge_y = 0.5)  


# Tour of geoms: different text
ggplot(mtcars, aes(x = factor(cyl))) +  geom_bar() +
  annotate("text", label = c("4 cyl", "6 cyl", "8 cyl"),
           x = 1:3, y = max(table(mtcars$cyl)) + 2, col = "red")


# Tour of geoms: density

ggplot(mtcars, aes(mpg)) + geom_density()
ggplot(mtcars, aes(mpg, fill=factor(cyl))) + geom_density()
ggplot(mtcars, aes(mpg, fill=factor(cyl))) +
  geom_density(alpha = 0.5) 

# Tour of geoms: histogram
ggplot(mpg, mapping = aes(x = hwy)) +
  geom_histogram(binwidth = 5)

mpg %>% filter(manufacturer == "audi") %>%
  ggplot(aes(x=hwy)) + geom_histogram(binwidth = 1)

mpg %>% filter(manufacturer == "audi") %>%
  ggplot(aes(x=log(hwy))) + geom_histogram(binwidth = .01)

ggplot(mpg, aes(x=log(hwy))) + geom_histogram(binwidth = .01) +
  facet_wrap(vars(manufacturer, year))  


# More with Faceting
p <- ggplot(mtcars, aes(mpg, wt)) +
  geom_point() +
  facet_wrap(~ cyl, nrow=2)  
df_wt <- mtcars %>% group_by(cyl) %>% summarize(avg_wt = mean(wt)) %>% as.data.frame()
p + geom_hline(aes(yintercept = avg_wt), data=df_wt)

# Grouped data
data("ChickWeight")  ## let's look at the data


datatable(ChickWeight, extensions = "Scroller",
          options = list(deferRender = TRUE,
                         scrollY = 300,
                         scroller = TRUE))

ggplot(ChickWeight, aes(Time, weight)) + geom_line()

ggplot(ChickWeight, aes(Time, weight, group = Chick)) + geom_line()

ggplot(ChickWeight, aes(Time, weight, group = Chick)) + geom_line() +
  geom_smooth(aes(group = 1), linewidth = 2, se = FALSE)

p <- ggplot(ChickWeight, aes(as.factor(Time), weight)) + geom_boxplot()
p


# Group option: mixing types

p + geom_line(aes(group = Chick, color = "pink4"))

p + geom_line(aes(group = Chick), color = "pink4", alpha = .50)

p + geom_smooth(aes(group = Chick), method="lm", se = FALSE)

p + geom_line(stat = "smooth", aes(group = Chick), method = "lm", alpha = .20)


# Labels, Axes, & Themes
# Labels
ggplot(mpg, aes(x=cty, y=hwy)) + geom_point() +
  labs(x="does this", y="work?", title="Awesome?",
       subtitle="too much?",

# Axes: ranges

ggplot(mpg, aes(x=cty, y=hwy)) + geom_point() +
  ylim(0, 50) + xlim(0, 50)

# Labels: legend

ggplot(mpg, aes(x=cty, y=hwy)) + 
  geom_point(aes(color = factor(cyl), shape = trans))


ggplot(mpg, aes(x=cty, y=hwy)) + 
  geom_point(aes(color = factor(cyl), shape = trans)) +
  labs(color = "Cylinder", shape = "Transmission") 

# Labels: no legend

ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +  geom_bar() +
  guides(fill="none") 

# Labels: legend position

ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +  geom_bar() +
  scale_color_brewer(palette = "Pastel1") + 
  theme(legend.position.inside = c(.50, .80))

# Themes
# Themes: black & white
ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point() +
  theme_bw() 

# Themes: classic
ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point() +
  theme_classic() 

# Themes: dark
ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point() +
  theme_dark() 

# Now what?
p <- ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) + geom_point()
ggsave("my_plot.pdf", p)
ggsave("my_plot.jpeg", p)


# Saving ggplots: multiple panels

p1 <- ggplot(mtcars, aes(x = hp, y = mpg)) + geom_point()
p2 <- ggplot(mtcars, aes(x = factor(cyl), y = hp)) + geom_boxplot()
grid.arrange(p1, p2, nrow = 1)

# make a list to hold the plots we want to include
gg_list <- list(p1, p2)
p3 <- ggplot(mtcars, aes(mpg, wt)) + facet_wrap( ~ cyl, nrow = 1)
gg_list[[3]] <- p3  ## add p3 in the 3rd position

# matrix for plot position
lay <- rbind(c(1,2),  # first row includes p1 & p2
             c(3, 3)) # second row stretches p3 across both columns

# create the figure with 3 panels & labels
grid.arrange(grobs = gg_list, layout_matrix = lay,
              top = "Figure X", bottom = "source: XXXX")

# Saving ggplots: multiple pages
ChickWeight %>% filter(Chick == 1) %>%
  ggplot(aes(Time, weight)) + geom_point() + geom_smooth() +
  labs(title = "Chick 1")

gg_list <- list()
n <- length(unique(ChickWeight$Chick))
for (i in 1:n) {
  gg_list[[i]] <- ChickWeight %>% filter(Chick == i) %>%
    ggplot(aes(Time, weight)) + geom_point() + geom_smooth() +
    labs(title = paste("Chick", i))
}
mg <- marrangeGrob(gg_list, nrow=1, ncol=1) 
ggsave("chicken_growth_trajectories.pdf", mg)
