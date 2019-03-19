## SPATIAL
library(sp)
library(rgeos)
library(raster)
library(rgdal)
library(maptools)
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
#----------------------------------------------------------------------------

#############################################################################
## GENERATE FIREPOKER LINK FOR FIRE
#############################################################################

# fire location
fire_info <- tibble(lon = -88.54618, 
                    lat = 37.41591,
                    name = "Lockridge Rx Fire")


# Generate firepoker link
fire_loc <- fire_info %>% 
  select(-name)

# specify coordinates
coordinates(fire_loc) <- c("lon", "lat")
proj4string(fire_loc) <- CRS("+init=epsg:4326")

# transform to bbox CRS
fire_loc_3857 <- spTransform(fire_loc, CRS("+init=epsg:3857"))@coords

# bbox data: xmin, ymin, xmax, ymax
bbox_ctds <- c(fire_loc_3857[1] + -1016307,
               fire_loc_3857[2] - 489197,
               fire_loc_3857[1] - -1016307,
               fire_loc_3857[2] + 489197)



# read in dispersion breakpoints and id the state where fire is happening
disp_brkpts_df <- read_excel("raw_data/disp_breakpoints.xlsx")
states <- st_read("gis/states")
fire_info_sf <- st_as_sfc(fire_loc)
state_sf <- st_transform(states, crs = st_crs(fire_info_sf))
fire_state <- as.character(states$STATE_ABBR[st_intersects(fire_info_sf, state_sf)[[1]]])


disp_brkpts <- disp_brkpts_df %>% 
  filter(state == fire_state) 


# create firepoker link
fp_url <- paste("https://www.weather.gov/dlh/firepoker?lat=",
                round(fire_info$lat, 3),
                "&lon=",
                round(fire_info$lon, 3),
                "&clat=",
                round(fire_info$lat, 3),
                "&clon=",
                round(fire_info$lon, 3),
                "&zoom=6&bbox=[",
                round(bbox_ctds[1], 3),
                ",",
                round(bbox_ctds[2], 3),
                ",",
                round(bbox_ctds[3], 3),
                ",",
                round(bbox_ctds[4], 3),
                "]&layers=FFFTTTTFFFT&fwf=F&dispersion=",
                paste(0, 
                      disp_brkpts[2], 
                      disp_brkpts[3],
                      disp_brkpts[4],
                      disp_brkpts[5],
                      sep = ","),
                sep = "")


fp_url





