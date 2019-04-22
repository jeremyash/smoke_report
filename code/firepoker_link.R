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

fp_url <- function(LON, LAT) {

  # fire location
  fire_loc <- tibble(lon = LON, 
                      lat = LAT)
  
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
                  round(fire_loc$lat, 3),
                  "&lon=",
                  round(fire_loc$lon, 3),
                  "&clat=",
                  round(fire_loc$lat, 3),
                  "&clon=",
                  round(fire_loc$lon, 3),
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
  
  # print(fp_url)
  browseURL(fp_url, browser = "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe",
            encodeIfNeeded = FALSE)

}



#ramshorn
fp_url(-79.741, 38.389)


# whoopie cat
fp_url(-88.32150, 37.48121)


# fink sandstone
fp_url(-88.71471, 37.50266)


# harris
fp_url(-88.27980, 37.55070)



# copperous
fp_url(-88.56281, 37.46626)


# pleasant_valley
fp_url(-88.54618, 37.41591)


# bluegrass
fp_url(-82.5272, 38.6194)


# house branch diamond
fp_url(-86.56423, 38.06897)



# patoka lake
fp_url(-86.68652, 38.41337)


# buskirk
fp_url(-80.228661, 37.832761)


# jeffries
fp_url(-86.480140, 38.173467)


# riddle
fp_url(-86.439198, 38.159302)


# copperous
fp_url(-88.56281, 37.46626)

# il tract
fp_url(-89.5286, 37.8591)

# fork ridge
fp_url(-86.199587, 39.003179)  

# big mtn
fp_url(-79.59458, 38.60374)  


# clover lick
fp_url(-86.536, 38.053)  


# west celina
fp_url(-86.632, 38.191)  
