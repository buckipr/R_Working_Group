library(dplyr)
cdc_url <- "https://data.cdc.gov/api/views/y5bj-9g5w/rows.csv?accessType=DOWNLOAD&bom=true&format=true%20target="
cdc_data <- read.csv(cdc_url)
names(cdc_data)

## oh_url <- "https://coronavirus.ohio.gov/static/COVIDSummaryData.csv"
## oh_dashboard_data <- read.csv(cdc_url)
## names(oh_dashboard_data)

## # longitudinal data
## alcohol_url <- "https://stats.idre.ucla.edu/stat/r/examples/alda/data/alcohol1_pp.txt"
## alcohol_data <- read.table(alcohol_url, header=T, sep=",")
## names(alcohol_data)

## Grammar for Rows: (1) filter; (2) slice; & (3) arrange

## Grammar for Rows: filter
names(cdc_data)
table(cdc_data$Jurisdiction)
oh_data <- filter(cdc_data, Jurisdiction == "Ohio")
dim(cdc_data)
dim(oh_data)
unique(oh_data$Jurisdiction)

#### now with a pipe
oh_data2 <- cdc_data %>%
    filter(Jurisdiction == "Ohio")
identical(oh_data, oh_data2)

#### filter with multiple conditions
table(cdc_data$Age.Group)
young <- c("Under 25 years", "25-44 years")
young_oh_data <-  cdc_data %>% filter(Jurisdiction == "Ohio" & 
                                      Age.Group %in% young)
dim(young_oh_data)
unique(young_oh_data$Jurisdiction)
unique(young_oh_data$Age.Group)

#### filter with functions
summary(cdc_data$Number.of.Deaths)
hi_mort_oh_data <-  cdc_data %>% filter(Jurisdiction == "Ohio" &
                                        Number.of.Deaths > mean(Number.of.Deaths, na.rm = TRUE))
dim(hi_mort_oh_data)
summary(hi_mort_oh_data$Number.of.Deaths)

###### take out missing (NA's)
hi_mort_oh_data2 <-  cdc_data %>%
    filter(!is.na(Number.of.Deaths)) %>%  ## very clear what is happening with 2 separate steps
    filter(Jurisdiction == "Ohio" &  Number.of.Deaths > mean(Number.of.Deaths))
summary(hi_mort_oh_data$Number.of.Deaths)

## Grammar for Rows: slice
oh_data %>% slice(1:20) ## drop rows with negative indices

oh_data %>% slice_head(prop = .03)
nrow(oh_data %>% slice_head(prop = .03))
nrow(oh_data) * .03

oh_data %>% slice_tail(n = 10)

names(oh_data)
oh_data %>% slice_min(Number.of.Deaths, n = 10)
oh_data %>% slice_max(Number.of.Deaths, n = 10)

## Grammar for Rows: arrange 
## (might need for plotting by date)
names(cdc_data)

date_example <- cdc_data[c(5:1, 3635:3600), c(1:4, 7)]
date_example
date_example$week_ending <- as.Date(date_example$Week.Ending.Date,
                                    format = "%m/%d/%Y")
date_example %>% arrange(week_ending)

#### organize by Year & descending number of deaths
date_example %>% arrange(Jurisdiction, Year, desc(Number.of.Deaths))

###### puts missing (NA's) at the end
date_example$Number.of.Deaths[11] <- NA
date_example %>% arrange(Jurisdiction, Year, desc(Number.of.Deaths))



## Grammar for Columns: select()
## (note can also use this for rearranging columns, if ever needed)
oh_data <- cdc_data %>%
    select(Jurisdiction, Week.Ending.Date, Number.of.Deaths, Year) %>%
    filter(Jurisdiction == "Ohio")
dim(cdc_data)
dim(oh_data)
names(oh_data)

#### removing variables
names(cdc_data)
cdc_data <- cdc_data %>%
    select(-c(Suppress, Note))
names(cdc_data)

#### helper functions:
#### starts_with()
#### ends_with()
#### contains()
#### matches()

cdc_data %>%
    slice(1:20) %>%
    select(starts_with("Jur"))
names(cdc_data)

## Grammar for Columns: rename()
names(oh_data)
oh_data <- oh_data %>%
    rename(date = Week.Ending.Date)
names(oh_data)

## Grammar for Columns: mutate() -- creating new variables
names(oh_data)
oh_data <- oh_data %>%
    mutate(deaths_per_k = Number.of.Deaths/1000,
           name_yr = paste0(Jurisdiction, Year),
           cdeaths = cumsum(Number.of.Deaths),
           cdeaths_pre_k = cdeaths/1000)
head(oh_data, n = 20)

#### cumprod()
#### cummin() & cummax()
#### cummean()
#### min_rank() & percent_rank() & ntile()
oh_data %>%
    slice(1:20) %>%
    select(Number.of.Deaths) %>%
    mutate(rank = min_rank(Number.of.Deaths),    ## min -- refers to ties (assign min)
           pct = percent_rank(Number.of.Deaths), ## rescale min_rank to [0,1]
           pct2 = percent_rank(desc(Number.of.Deaths)),
           pct3 = ntile(Number.of.Deaths, n = 3))    ## create n groups of roughly same size ordered by variable

###### min_rank example
X <- c(24,22,22,23,21)
min_rank(X)
#> [1] 5 2 2 4 1
rank(X, ties.method = "min")
#> [1] 5 2 2 4 1
rank(X, ties.method = "max")
#> [1] 5 3 3 4 1


## Grammar for Rows: summarize()
names(cdc_data)
all_oh_data <- cdc_data %>%
    filter(Jurisdiction == "Ohio" & Type == "Unweighted") %>%
    select(Week.Ending.Date, Year, Age.Group, Number.of.Deaths) %>%
    mutate(week = as.Date(Week.Ending.Date, format = "%m/%d/%Y"))
names(all_oh_data)

all_oh_data %>%
    filter(Age.Group == "25-44 years") %>%
    summarize(n_deaths = sum(Number.of.Deaths))

## sum over age goups (can use group_by() with multiple variables)
all_oh_data %>%
    group_by(Age.Group) %>%
    summarize(n_deaths = sum(Number.of.Deaths))

all_oh_data %>%
    group_by(Age.Group, Year) %>%
    summarize(n_deaths = sum(Number.of.Deaths))
#### what does the message mean?
#### each call to summarize removes a groups 

all_oh_data %>%
    group_by(Year, Age.Group) %>%
    summarize(n_deaths = sum(Number.of.Deaths)) %>%
    summarize(n_deaths2 = sum(n_deaths))
#### Age.Group is removed (since it is the last one)


#### you can also apply more verbs...
all_oh_data %>%
    group_by(Year, Age.Group) %>%
    summarize(n_deaths = sum(Number.of.Deaths)) %>%
    filter(n_deaths > 25000)


#### more useful functions with summarize
all_oh_data %>%
    group_by(Week.Ending.Date) %>%
    summarize(n_deaths = sum(Number.of.Deaths),
              n = n(),                      ## number of age groups per week
              mu = mean(Number.of.Deaths),  ## mean of age group
              sd = sd(Number.of.Deaths),    ## sd across
              iqr = IQR(Number.of.Deaths),
              unique = n_distinct(Number.of.Deaths))

## n_distinct()

## Another useful summary function:
## count() -- count unique number of values for 1 or more variables
##            (basically a frequency table)
all_oh_data %>%
    count(Year, Age.Group)


#### total number of monthly deaths by year?
monthly_data <- all_oh_data %>%
    arrange(week) %>%
    group_by(Year, week) %>%
    summarize(n_wkly_deaths = sum(Number.of.Deaths)) %>%
    mutate(month = format(week, "%m")) %>%
    group_by(Year, month) %>%
    summarize(n_m_deaths = sum(n_wkly_deaths))
print(monthly_data, n=70)

###### Note: this is weird because of wk numbers (Year doesn't quite match up)
###### (depends on if most of the week was in a particular year --> 2016-01-02)
## monthly_data <- all_oh_data %>%
##     arrange(week) %>%
##     mutate(yr = format(week, "%Y")) %>%
##     group_by(yr, week) %>%
##     summarize(n_wkly_deaths = sum(Number.of.Deaths)) %>%
##     mutate(month = format(week, "%m")) %>%
##     group_by(yr, month) %>%
##     summarize(n_m_deaths = sum(n_wkly_deaths))
## print(monthly_data, n=70)


# how to number observations within groups (longitudinal data
# like Stata: person_id = _n
all_oh_data %>%
    group_by(week) %>%
    summarize(n_deaths = sum(Number.of.Deaths)) %>%
    mutate(month = format(week, "%m"),
           yr = format(week, "%Y")) %>%
    group_by(yr, month) %>%
    arrange(week) %>%
    mutate(wk_num = 1:n())
    
