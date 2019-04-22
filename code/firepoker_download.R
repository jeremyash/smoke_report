## SPATIAL
library(sp)
library(rgeos)
library(raster)
library(rgdal)
library(maptools)

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

library(rvest)
library(webshot)
#----------------------------------------------------------------------------

# fire information
fire_info <- tibble(longitude = -82.22618525756064, 
                    latitude = 39.53743368404867,
                    name = "Wayne NF Rx Fire")


#firepoker url: last set of numbers are break points for ventilation index. unknown coordiante system for bounding box

fp_url <- paste("https://www.weather.gov/dlh/firepoker?lat=",
                fire_info$latitude,
                "&lon=",
                fire_info$longitude,
                "&zoom=8.182931486309556&bbox=[-9158699.49,4879477.111,-8657732.783,5094946.663]&layers=FFFTTTTFFFT&fwf=F&dispersion=0,40,60,100,150",
                sep = "")
                
#Multiple Selector Based Screenshots
webshot("https://www.weather.gov/dlh/firepoker",
        delay = 120,
        file = "figures/test_map.png")


library(RSelenium)
rD <- rsDriver(browser = "chrome")
remDr <- rD[['client']]
remDr$navigate("https://www.weather.gov/dlh/firepoker")
remDr$screenshot(file = tf <- tempfile(fileext = ".png"))
shell.exec(tf) # on windows
remDr$close()
rD$server$stop()

