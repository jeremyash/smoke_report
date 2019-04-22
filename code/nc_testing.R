## SPATIAL
library(sp)
library(rgeos)
library(raster)
library(rgdal)
library(maptools)
library(ggmap)
library(sf)

## DATA MANAGEMENT
library(tidyverse)
library(skimr)
library(patchwork)
library(readxl)
# library(zoo)

## PLOTTING
library(scales)
library(units)
library(viridis)
library(extrafont)
library(gtable)
library(grid)
library(ggimage)
library(gridExtra)
library(knitr)
library(kableExtra)
library(egg)
library(tidycensus)

## SMOKE DATA
library(PWFSLSmoke)
library(MazamaSpatialUtils)

# ncdf hyspli testing
library(ncdf4)
library(rjson)



# automate download using link from bluesky outtput...NEED TO DO THIS

# hys_nc <- nc_open("raw_data/hysplit_conc_copperous.nc")
# 
# print(hys_nc)
# 
# # time steps
# t <- ncvar_get(hys_nc,"TFLAG")
# 
# nc_close(hys_nc)

#############################################################################
## LOAD DATA
#############################################################################

# get extent of hysplit grid in lat/long
grid_info <- fromJSON(file="raw_data/grid_info_copperous.json")[[1]]

# reorder to use as extent object with rasters below
grid_info <- c(grid_info[1], 
               grid_info[3],
               grid_info[2],
               grid_info[4])

# create raster stack
hys_brick <- brick("raw_data/hysplit_conc_copperous.nc")
extent(hys_brick) <- grid_info
crs(hys_brick) <- CRS("+init=epsg:4326")


# fire location
fire_info <- read_csv("raw_data/fire_locations_copperous.csv")
fire_ctds <- SpatialPoints(data.frame(fire_info$longitude, 
                                      fire_info$latitude), 
                           proj4string = CRS("+init=epsg:4326"))



#############################################################################
## PROJECT AND CROP RASTER TO FIRE BUFFER
#############################################################################

# crop to 10 x 10 degree box around fire source...first step to increasing speeed
bbox_ctds <- c(fire_info$longitude + -5,
               fire_info$longitude + 5,
               fire_info$latitude - 5,
               fire_info$latitude + 5)

hys_brick_crop <- crop(hys_brick, bbox_ctds)


## project hys_brick and crop to 10 mile buffer around fire source
albers_crs <- CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs")

# project fire and create 10 mile buffer
fire_ctds <- spTransform(fire_ctds, albers_crs)
fire_buffer <- gBuffer(fire_ctds, width = 16093.4) # 10 mile buffer

# project hysplit and crrop to buffer and then retrun to lat/long
hys_brick_crop_albers <- projectRaster(hys_brick_crop, crs = albers_crs)
hys_brick_fire_albers <- crop(hys_brick_crop_albers, fire_buffer)
hys_brick_fire <- projectRaster(hys_brick_fire_albers, crs = CRS("+init=epsg:4326"))


#############################################################################
## CALCULATE DAILY STATS
#############################################################################

# calculate day one avg and max
day_one <- hys_brick_fire[[seq(1,24,1)]]
  
day_one_avg <- calc(day_one, mean)
day_one_max <- calc(day_one, max)

summary(day_one_max)


col_pal <- brewer_pal(palette = "Reds")(9)


plot(day_one_max,
     ext = c(-90, -88, 37.3, 38.8),
     breaks = c(1,5,10,20,40,90,140,350,525),
     col = col_pal) 

points(x = -88.56281,
     y = 37.46626)




# uni-color graph with map

# set up google API for ggmap ./md_data/
api <- readLines("./google.api")
register_google(key = api)

# read in fire icon for mapping
fire_icon <- tibble(x = -88.56281,
                    y = 37.46626,
                    image = "icons/redFlame.png")



day_one_max_df <- 

# pull fire map from google
fire_map_info <- get_map(location = c( -88.56281, 37.46626),
                         maptype = "terrain",
                         zoom = 8)

# plot fire map
ggmap(fire_map_info, extent = "device") +
  geom_image(aes(x = x, y = y, image = image), data = fire_icon) +
  geom_raster(data = day_)
  
  
  
  
  geom_point(aes(x = longitude, y = latitude, color = aqi_cat), size = 3, show.legend = FALSE, data = rec_daily_df) +
  scale_color_manual(values = rec_daily_df$aqi_col)










# 
# # calculate day two avg and max
# day_two <- hys_brick[[seq(25,47,1)]]
# 
# day_two_avg <- calc(day_two, mean)
# day_two_max <- calc(day_two, max)
# 
# summary(day_two)
# 
# col_pal <- brewer_pal(palette = "Reds")(9)
# plot(day_two_max,
#      ext = c(-89, -88, 37.3, 37.8),
#      breaks = c(1,5,10,20,40,90,140,350,525),
#      col = col_pal) 
# 

  
  




