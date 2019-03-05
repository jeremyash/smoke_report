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
hys_nc <- nc_open("md/hysplit_conc.nc")
print(hys_nc)





nc_close(hys_nc)

# hys_nc <- raster("md/hysplit_conc.nc")

plot(hys_nc)
