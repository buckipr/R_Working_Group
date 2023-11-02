### Mapping Basics
## Beth Boettner
# IPR Fall 2023

library(tidyverse)
library(sf)
library(tidycensus)
# https://walker-data.com/tidycensus/
# get your own census API key for using this package (this is mine)
# A key can be obtained from http://api.census.gov/data/key_signup.html
# for more info see:
# https://walker-data.com/census-r/an-introduction-to-tidycensus.html#getting-started-with-tidycensus
census_api_key("ENTER YOUR KEY HERE")
library(leaflet)

# downloaded Columbus points of interest from MORPC:
# https://public-morpc.hub.arcgis.com/datasets/cfdff68f2c8b4fb0909f385f6d645925_0/explore?location=39.938001%2C-83.023069%2C8.67
cbuspts <- read.csv("Points_of_Interest.csv")

# keep just the schools in Franklin County to make it easier to visualize
cbuspts <- cbuspts %>% filter(CATEGORY == "EDU" & COUNTY == "FRA")

# use SF to make it a spatial data frame
# st_as_sf(data, coords = c("longitude_var", "latitude_var"), crs= ####)
# this morpc data use the Ohio South state plane in ft CRS 3735 (found info in metadata)
# XY data is normally in decimal degrees and would use crs=4326
schoolsf <- st_as_sf(cbuspts, coords = c("X", "Y"), crs= 3735)
# may need to transform later to 4326
# check plot
plot(schoolsf)
plot(st_geometry(schoolsf))

rm(cbuspts)

#############
# get polygon shapefile
#############

# now pull in franklin county tracts to join using tidycensus get_acs() with geometry

# list of available variables for 2016-2020 ACS 5 year data to get right variable name 
tr2020vars <- load_variables(2020, "acs5", cache = TRUE)
# poverty is B17001_002, poverty population is B17001_001
rm(tr2020vars)

# use get_acs to get geometry and tract variables at the same time
# can request more than one variable at a time if give the package a list, just doing one for now
# specifying I just want tracts in Ohio/Franklin county, and that I want the geometry (=TRUE)

tr1620 <- get_acs(geography = "tract",  variables = "B17001_002", summary_var = "B17001_001",
                  state = "OH", county = "Franklin", geometry = TRUE, year = 2020)
# make a poverty rate out of the total
tr1620 <- tr1620 %>% mutate(tractpov=estimate/summary_est) 
# cut into 3 and 5 groups to visualize
tr1620 <- tr1620 %>% mutate(pov3=cut(tractpov, breaks = c(0,.2,.4,1)))
tr1620 <- tr1620 %>% mutate(pov5=cut(tractpov, breaks = c(0,.1,.2,.3,.4, 1)))

###########
## If have an existing shapefile, use st_read() from sf package
###########
oh_bg17 <- st_read("tl_2018_39_bg/franklin18_bg.shp")
# change projection if needed
# oh_bg17 <- st_transform(oh_bg17, "+proj=longlat +datum=WGS84")

#################
## plotting basics
################

# plot both - basic outline of the tracts and no frills
ggplot() +
  geom_sf(data = tr1620) +
  geom_sf(data = schoolsf)

# now add color - points by school type
ggplot() +
  geom_sf(data = tr1620) +
  geom_sf(data = schoolsf, aes(color = TYPE))

# now add color - tracts by poverty level
# pick just the high schools to make it easier to see
hs <- schoolsf %>% filter(TYPE == "HIGH SCHOOL")

# fill_scale_ options in ggplot all work for maps as well
# i'm using a color brewer scale that comes with ggplot that goes from Yellow to Green to Blue
# Color Brewer palettes work best for discrete categories
# https://ggplot2.tidyverse.org/reference/scale_brewer.html
# I'll make the color of the schools magenta, and increase the size to 2
ggplot() +
  geom_sf(data = tr1620, aes(fill = pov5)) +
  scale_fill_brewer(palette = "YlGnBu") +
  geom_sf(data = hs, color = "magenta", size = 2)

# continuous poverty measures using the viridis palette for continuous data
# https://ggplot2.tidyverse.org/reference/scale_colour_continuous.html
ggplot() +
  geom_sf(data = tr1620, aes(fill = tractpov)) +
  scale_fill_viridis_c() +
  geom_sf(data = hs, color = "magenta", size = 2)


###################
# Interactive mapping in Leaflet
###################
# mapping in leaflet requires using crs 4326 for lat/long in decimal degrees
hs <- st_transform(hs, crs=4326)
tr1620 <- st_transform(tr1620, crs=4326)

# addTiles() gets you open street maps, can change to other basemaps, but not google with changes to google API
leaflet() %>%
  addTiles() %>%
  addPolygons(data = tr1620, weight=1) %>%
  addCircles(data = hs, label = hs$NAME, color = "magenta")

# more complicated to change the color of polygons by leaflet
# need to define the palette and any bins ahead of time
povpal <- colorNumeric(
  palette = "Blues",
  domain = tr1620$tractpov)

leaflet() %>% addTiles() %>%
  addPolygons(data = tr1620, fillColor = ~povpal(tractpov), fillOpacity = 1, weight=1) %>%
  addCircles(data = hs, label = hs$NAME, color = "magenta")

#categorical and add in high schools
factpal <- colorFactor(palette = "YlGnBu" , tr1620$pov5)

leaflet(tr1620) %>%
  addTiles() %>%
  addPolygons(fillColor = ~factpal(pov5),
  weight = .5,
  opacity = 1,
  fillOpacity = 0.7) %>%
    addLegend(pal = factpal, values = ~pov5, opacity = 0.7,
              title = "Poverty Level", position = "topleft") %>% 
  addCircles(data = hs, label = hs$NAME, color = "magenta", weight = 10)
  


##############
# spatial joins
###############
# join tracts to the HS list so we can get tract statistics about each school
# first must set both to the same CRS - ggplot will manage it in background but st_join needs explicit
# change the points from NAD83 state plane to more general NAD83 crs=4269 for US that the tracts come in
hs <- st_transform(hs, crs=4269)
tr1620 <- st_transform(tr1620, crs=4269)

hstr <- st_join(hs, tr1620)
hstr
summary(hstr$tractpov)

# if need to keep points that don't match/overlap, use left = TRUE
hstr <- st_join(hs, tr1620, left = TRUE)
# in this case, they are the same since I previously limited the schools to Franklin county

hspov <- hstr %>% filter(tractpov>.3)
                  
ggplot() +
  geom_sf(data = tr1620, aes(fill = tractpov)) +
  scale_fill_viridis_c() +
  geom_sf(data = hspov, color = "magenta", size = 2)


#############
# Making a buffer - circle radius around an point
###############

# make a buffer of however many meters around a place
# In this example, I use CRS for Ohio South Plane that is given in meters for the buffering 
# That way I can specify the buffer in meters. There is also a version in feet

hs2835 <-  hs %>% st_transform(crs=2835)
# 30 meter buffer 
hs_buffer <- st_buffer(hs2835, 500)

# back to CRS 4326 for mapping in leaflet
hs_buffer <- st_transform(hs_buffer, crs=4326)
hs <- st_transform(hs, crs=4326)

leaflet() %>%
  addTiles() %>%
  addPolygons(data = hs_buffer) %>%
  addCircles(data = hs, color = "magenta")

# check the buffers against a list of other points to see any of them fall within 500 meters of that HS
# pull out the middle schools from the schoolsf data
ms <- schoolsf %>% filter(TYPE == "MIDDLE SCHOOL") %>% st_transform(crs=4326)

leaflet() %>%
  addTiles() %>%
  addPolygons(data = hs_buffer) %>%
  addCircles(data = hs, color = "magenta")  %>%
  addCircles(data = ms, color = "yellow")


# st_intersection will give you a dataframe of the two sources merged together if there are matches 
# ie if a MS falls within the 500m buffer of a HS we set
intersect <- st_intersection(hs_buffer, ms)
# lots of options for intersections. 
# I believe st_intersect() will just give you a matrix back of which items intersect if you don't want the full combo



######################
# calculate distances 
#####################

# calc distance from every HS to townshend hall
pt <- data.frame(lat= 40.00002580088986, long=-83.01562264232848)
townshend <- st_as_sf(pt, coords=c("long", "lat"), crs = 4326)
# make a vector of the schools to put the calculated distances
dist <- hs %>% st_set_geometry(NULL) %>% select(UNIQID)
dist$distm <-  st_distance(hs, townshend)
# may need to drop the units for other calculations
library(units)
dist$distm  <- drop_units(dist$distm)
dist$distkm <-  dist$distm/1000

# merge back in
hs <-  left_join(hs, dist)



