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
library(png)
library(rjson)
library(curl)
library(RCurl)

## PLOTTING
library(scales)
library(units)
library(viridis)
library(extrafont)
library(gtable)
library(grid)
library(ggmap)
library(ggimage)
library(leaflet)
library(htmlwidgets)
#----------------------------------------------------------------------------

#############################################################################
## LEAFLET GENERAL FUNCTION
#############################################################################


##-------------
## general data
##-------------

# bluesky PM color codes and binds
bsky_col <- read_csv("raw_data/bsky_gray_color_ramp.csv",
                     trim_ws = TRUE) 



##-------------
## download and extract files
##-------------

# function to download and extract necessary files

bsky_file_download_fun <- function(DISP_ID) {
  
    # smoke dispersion
  smoke_disp_link <- paste("https://playground-2.airfire.org/bluesky-web-output/",
                           DISP_ID,
                           "-dispersion/output/smoke_dispersion.kmz", sep = "")
  
  # download smoke dispersion into a zip and regular version 
  curl_download(smoke_disp_link, destfile = "gis/testing/smoke_dispersion.kmz.zip")
  curl_download(smoke_disp_link, destfile = "gis/testing/smoke_dispersion.kmz")
  
  # create directory for smoke dispersion files
  dir.create("gis/testing/smoke_dispersion_files")
  
  # unzip the file
  unzip(zipfile = "gis/testing/smoke_dispersion.kmz.zip",
        exdir = "gis/testing/smoke_dispersion_files")
  
  # get rid of zip file
  file.remove("gis/testing/smoke_dispersion.kmz.zip")
  
  # grid info to get extent of png files
  grid_info_link <- paste("https://playground-2.airfire.org/bluesky-web-output/",
                          DISP_ID, 
                          "-dispersion/output/grid_info.json", sep = "")
  
  # download grid info
  curl_download(grid_info_link, destfile = "gis/testing/smoke_dispersion_files/grid_info.json")
  
  
  # fire location info and UTC offset
  fire_loc_link <- paste("https://playground-2.airfire.org/bluesky-web-output/",
                         DISP_ID, 
                         "-dispersion/output/data/fire_locations.csv", sep = "")
  
  # download fire locations
  curl_download(fire_loc_link, destfile = "gis/testing/smoke_dispersion_files/fire_locations.csv")
  
}

bsky_file_download_fun("15e2aec893afb9")






##-------------
## re-code rasters
##-------------


# function to generate rasters needed for plotting
bsky_raster_gen_fun <- function(YYYYMMDD) {
  
  # fire ctds
  fire_loc <- read_csv("gis/testing/smoke_dispersion_files/fire_locations.csv")

  # fire CRS
  fire_crs <- st_crs(read_sf("gis/testing/smoke_dispersion_files/doc.kml"))
  
  # read PNG files
  day_one_max <- readPNG(paste("gis/testing/smoke_dispersion_files/100m_daily_maximum_", 
                                fire_loc$date_time, 
                                "_UTC",
                                gsub(":", "", fire_loc$utc_offset), 
                               ".png", sep = ""))
  
  day_one_avg <- readPNG(paste("gis/testing/smoke_dispersion_files/100m_daily_average_", 
                               fire_loc$date_time, 
                               "_UTC",
                               gsub(":", "", fire_loc$utc_offset),
                               ".png", sep = ""))
  
  
  # pull extent from grid_info.json
  grid_info <- fromJSON(file="gis/testing/smoke_dispersion_files/grid_info.json")[[1]]
  
  
  # read in fire icon for mapping
  fire_icon <- tibble(x = fire_loc$longitude,
                      y = fire_loc$latitude,
                      image = "icons/redFlame.png")
  
  
  # collapse RGB bands into one with hex codes as values
  day_one_max_r <- as.raster(day_one_max)
  day_one_avg_r <- as.raster(day_one_avg)
  
  # replace hex codes with PM categories
  day_one_max_r[day_one_max_r == "#C8C8C8B2"] <- bsky_col$pm[bsky_col$hex == "#C8C8C8B2"] #1
  day_one_max_r[day_one_max_r == "#AFAFAFB2"] <- bsky_col$pm[bsky_col$hex == "#AFAFAFB2"] #2
  day_one_max_r[day_one_max_r == "#969696B2"] <- bsky_col$pm[bsky_col$hex == "#969696B2"] #3
  day_one_max_r[day_one_max_r == "#7D7D7DB2"] <- bsky_col$pm[bsky_col$hex == "#7D7D7DB2"] #4
  day_one_max_r[day_one_max_r == "#646464B2"] <- bsky_col$pm[bsky_col$hex == "#646464B2"] #5
  day_one_max_r[day_one_max_r == "#4B4B4BB2"] <- bsky_col$pm[bsky_col$hex == "#4B4B4BB2"] #6
  day_one_max_r[day_one_max_r == "#323232B2"] <- bsky_col$pm[bsky_col$hex == "#323232B2"] #7
  day_one_max_r[day_one_max_r == "#191919B2"] <- bsky_col$pm[bsky_col$hex == "#191919B2"] #8
  day_one_max_r[day_one_max_r == "#00000000"] <- bsky_col$pm[bsky_col$hex == "#00000000"] #0
  
  day_one_avg_r[day_one_avg_r == "#C8C8C8B2"] <- bsky_col$pm[bsky_col$hex == "#C8C8C8B2"] #1
  day_one_avg_r[day_one_avg_r == "#AFAFAFB2"] <- bsky_col$pm[bsky_col$hex == "#AFAFAFB2"] #2
  day_one_avg_r[day_one_avg_r == "#969696B2"] <- bsky_col$pm[bsky_col$hex == "#969696B2"] #3
  day_one_avg_r[day_one_avg_r == "#7D7D7DB2"] <- bsky_col$pm[bsky_col$hex == "#7D7D7DB2"] #4
  day_one_avg_r[day_one_avg_r == "#646464B2"] <- bsky_col$pm[bsky_col$hex == "#646464B2"] #5
  day_one_avg_r[day_one_avg_r == "#4B4B4BB2"] <- bsky_col$pm[bsky_col$hex == "#4B4B4BB2"] #6
  day_one_avg_r[day_one_avg_r == "#323232B2"] <- bsky_col$pm[bsky_col$hex == "#323232B2"] #7
  day_one_avg_r[day_one_avg_r == "#191919B2"] <- bsky_col$pm[bsky_col$hex == "#191919B2"] #8
  day_one_avg_r[day_one_avg_r == "#00000000"] <- bsky_col$pm[bsky_col$hex == "#00000000"] #0
  
  
  # convert to matrix and change values to numeric
  day_one_max_m <- matrix(as.numeric(day_one_max_r),
                          nrow = dim(day_one_max_r)[1],
                          ncol = dim(day_one_max_r)[2],
                          byrow = TRUE)
  
  day_one_avg_m <- matrix(as.numeric(day_one_avg_r),
                          nrow = dim(day_one_avg_r)[1],
                          ncol = dim(day_one_avg_r)[2],
                          byrow = TRUE)
  
  
  # convert to raster
  day_one_max_ras <- raster(day_one_max_m)
  day_one_avg_ras <- raster(day_one_avg_m)
  
  
  # ratify raster (convert to factor)
  day_one_max_ras <- ratify(day_one_max_ras)
  day_one_avg_ras <- ratify(day_one_avg_ras)
  
  # add levels of factor in dataframe
  levels(day_one_max_ras) <- data.frame(ID = c("1", "2", "3", "4", "5", "6", "7", "8"),
                                        pm = c("1-12", "12-55", "35-55", "55-150", "150-250", "250-350", "350-500", ">500"))
  
  
  levels(day_one_avg_ras) <- data.frame(ID = c("1", "2", "3", "4", "5", "6", "7", "8"),
                                        pm = c("1-12", "12-55", "35-55", "55-150", "150-250", "250-350", "350-500", ">500"))
  
  
  # set extent of raster
  extent(day_one_max_ras) <- extent(c(grid_info[1], 
                                      grid_info[3],
                                      grid_info[2],
                                      grid_info[4]))
  
  extent(day_one_avg_ras) <- extent(c(grid_info[1], 
                                      grid_info[3],
                                      grid_info[2],
                                      grid_info[4]))
  
  # same crs as the doc.kml
  crs(day_one_max_ras) <- fire_crs[["proj4string"]]
  crs(day_one_avg_ras) <- fire_crs[["proj4string"]]
  
  # list of two rasters
  day_one_ls <- list(day_one_max_ras, day_one_avg_ras, fire_icon)
  names(day_one_ls) <- c("day_one_max_ras", "day_one_avg_ras", "fire_icon")
  # return(day_one_ls)
}

# day_one_ls <- bsky_raster_gen_fun("20200124")


##-------------
## plot rasters
##-------------

# function to plot rasters in leaflet map
bsky_leaflet_plot_fun <- function(RAS_LS) {
  
  # pull out rastersand fire_icon into separate files
  day_one_max_ras <- RAS_LS[["day_one_max_ras"]]
  day_one_avg_ras <- RAS_LS[["day_one_avg_ras"]]
  fire_icon <- RAS_LS[["fire_icon"]]
  
  # bluesky color ramp
  pm_col_ramp <- bsky_col %>% 
    pull(hex_2)
  pm_col_ramp <- pm_col_ramp[-9]
  
  # create color palette function
  pal <- colorFactor(palette = pm_col_ramp,
                     levels = levels(day_one_max_ras)[[1]][1]$ID,
                     # levels = levels(day_one_max_ras)[[1]][2]$pm,
                     # domain = NULL,
                     na.color = "transparent")
  
  # generate leaflet map
  day_one_html <- leaflet() %>% 
    addTiles() %>%
    addRasterImage(day_one_max_ras, 
                   colors = pal,
                   opacity = 0.8, 
                   group = "Daily Maximum") %>%
    addRasterImage(day_one_avg_ras, 
                   colors = pal,
                   opacity = 0.8, 
                   group = "Daily Average") %>%
    addLegend(pal = pal, 
              # values = day_one_max_ras,
              # values = levels(day_one_max_ras)[[1]][2]$pm,
              values = levels(day_one_max_ras)[[1]][1]$ID,
              # labels =  c("1-12", "12-55", "35-55", "55-150", "150-250", "250-350", "350-500", ">500"),
              labFormat  = labelFormat(
                transform = function(x) {
                  levels(day_one_max_ras)[[1]]$pm[which(levels(day_one_max_ras)[[1]]$ID == x)]}),
              opacity = 0.8, 
              title = "PM2.5 (ug m^-3)") %>% 
    addMarkers(data = fire_icon, lng = ~x, lat = ~y,
               icon = list(
                 iconUrl = fire_icon$image,
                 iconSize = c(25, 25))) %>% 
    fitBounds(lng1 = fire_icon$x - 0.5,
              lat1 = fire_icon$y - 0.5,
              lng2 = fire_icon$x + 0.5,
              lat2 = fire_icon$y + 0.5) %>% 
    # Layers control
    addLayersControl(
      baseGroups = c("Daily Maximum", "Daily Average"),
      options = layersControlOptions(collapsed = FALSE)
    )
  
  
  saveWidget(day_one_html, file="day_one.html")

}

bsky_leaflet_plot_fun(day_one_ls)






#############################################################################
## LEAFLET
#############################################################################

# bluesky PM color codes and binds
bsky_col <- read_csv("raw_data/bsky_gray_color_ramp.csv",
                     trim_ws = TRUE) 

# file has been downloaded from https://tools.airfire.org/playground/v3/dispersionresults.php?scenario_id=15dcd95fca4852, renamed to kmz.zip, and extracted
fire_loc <- read_sf("gis/smoke_dispersion.kmz/doc.kml")
fire_crs <- st_crs(fire_loc)
fire_ctds <- st_geometry(fire_loc)

# read PNG file
day_one_max <- readPNG("gis/smoke_dispersion.kmz/100m_daily_maximum_20200124_UTC-0500.png")
str(day_one_max)

# pull extent from grid_info.json
grid_info <- fromJSON(file="gis/grid_info.json")[[1]]


# read in fire icon for mapping
fire_icon <- tibble(x = fire_ctds[[1]][1],
                    y = fire_ctds[[1]][2],
                    image = "icons/redFlame.png")


# collapse RGB bands into one with hex codes as values
day_one_max_r <- as.raster(day_one_max)

# replace hex codes with PM categories
day_one_max_r[day_one_max_r == "#C8C8C8B2"] <- bsky_col$pm[bsky_col$hex == "#C8C8C8B2"] #1
day_one_max_r[day_one_max_r == "#AFAFAFB2"] <- bsky_col$pm[bsky_col$hex == "#AFAFAFB2"] #2
day_one_max_r[day_one_max_r == "#969696B2"] <- bsky_col$pm[bsky_col$hex == "#969696B2"] #3
day_one_max_r[day_one_max_r == "#7D7D7DB2"] <- bsky_col$pm[bsky_col$hex == "#7D7D7DB2"] #4
day_one_max_r[day_one_max_r == "#646464B2"] <- bsky_col$pm[bsky_col$hex == "#646464B2"] #5
day_one_max_r[day_one_max_r == "#4B4B4BB2"] <- bsky_col$pm[bsky_col$hex == "#4B4B4BB2"] #6
day_one_max_r[day_one_max_r == "#323232B2"] <- bsky_col$pm[bsky_col$hex == "#323232B2"] #7
day_one_max_r[day_one_max_r == "#191919B2"] <- bsky_col$pm[bsky_col$hex == "#191919B2"] #8
day_one_max_r[day_one_max_r == "#00000000"] <- bsky_col$pm[bsky_col$hex == "#00000000"] #0


# convert to matrix and change values to numeric
day_one_max_m <- matrix(as.numeric(day_one_max_r),
                        nrow = dim(day_one_max_r)[1],
                        ncol = dim(day_one_max_r)[2],
                        byrow = TRUE)
# convert to raster
day_one_max_ras <- raster(day_one_max_m)


# ratify raster (convert to factor)
day_one_max_ras <- ratify(day_one_max_ras)

# add levels of factor in dataframe
levels(day_one_max_ras) <- data.frame(ID = c("1", "2", "3", "4", "5", "6", "7", "8"),
                                      pm = c("1-12", "12-55", "35-55", "55-150", "150-250", "250-350", "350-500", ">500"))


# rasterVis::levelplot(day_one_max_ras)


# set extent of raster
extent(day_one_max_ras) <- extent(c(grid_info[1], 
                                    grid_info[3],
                                    grid_info[2],
                                    grid_info[4]))

# same crs as the doc.kml
crs(day_one_max_ras) <- fire_crs[["proj4string"]]

# rasterVis::levelplot(day_one_max_ras)


# bluesky color ramp
pm_col_ramp <- bsky_col %>% 
  pull(hex_2)
pm_col_ramp <- pm_col_ramp[-9]

# create color palette function
pal <- colorFactor(palette = pm_col_ramp,
                   levels = levels(day_one_max_ras)[[1]][1]$ID,
                   # levels = levels(day_one_max_ras)[[1]][2]$pm,
                   # domain = NULL,
                   na.color = "transparent")

# generate leaflet map
day_one_max_html <- leaflet() %>% 
  addTiles() %>%
  addRasterImage(day_one_max_ras, 
                 colors = pal,
                 opacity = 0.8) %>%
  addLegend(pal = pal, 
            # values = day_one_max_ras,
            # values = levels(day_one_max_ras)[[1]][2]$pm,
            values = levels(day_one_max_ras)[[1]][1]$ID,
            # labels =  c("1-12", "12-55", "35-55", "55-150", "150-250", "250-350", "350-500", ">500"),
            labFormat  = labelFormat(
              transform = function(x) {
                levels(day_one_max_ras)[[1]]$pm[which(levels(day_one_max_ras)[[1]]$ID == x)]}),
            opacity = 0.8, 
            title = "PM2.5 (ug m^-3)") %>% 
  addMarkers(data = fire_icon, lng = ~x, lat = ~y,
             icon = list(
               iconUrl = fire_icon$image,
               iconSize = c(25, 25))) %>% 
  fitBounds(lng1 = fire_icon$x - 0.5,
            lat1 = fire_icon$y - 0.5,
            lng2 = fire_icon$x + 0.5,
            lat2 = fire_icon$y + 0.5)



# save as html

saveWidget(day_one_max_html, file="day_one_max.html")


#############################################################################
## USING GGMAP/GGPLOT
#############################################################################

# bluesky PM color codes and binds
bsky_col <- read_csv("raw_data/bsky_gray_color_ramp.csv",
                     trim_ws = TRUE) 

# file has been downloaded from https://tools.airfire.org/playground/v3/dispersionresults.php?scenario_id=15dcd95fca4852, renamed to kmz.zip, and extracted
fire_loc <- read_sf("gis/smoke_dispersion.kmz/doc.kml")
fire_crs <- st_crs(fire_loc)
fire_ctds <- st_geometry(fire_loc)

# read PNG file
day_one_max <- readPNG("gis/smoke_dispersion.kmz/100m_daily_maximum_20200124_UTC-0500.png")
str(day_one_max)

# collapse RGB bands into one with hex codes as values
day_one_max_r <- as.raster(day_one_max)

# replace hex codes with PM categories
day_one_max_r[day_one_max_r == "#C8C8C8B2"] <- bsky_col$pm[bsky_col$hex == "#C8C8C8B2"] #1
day_one_max_r[day_one_max_r == "#AFAFAFB2"] <- bsky_col$pm[bsky_col$hex == "#AFAFAFB2"] #2
day_one_max_r[day_one_max_r == "#969696B2"] <- bsky_col$pm[bsky_col$hex == "#969696B2"] #3
day_one_max_r[day_one_max_r == "#7D7D7DB2"] <- bsky_col$pm[bsky_col$hex == "#7D7D7DB2"] #4
day_one_max_r[day_one_max_r == "#646464B2"] <- bsky_col$pm[bsky_col$hex == "#646464B2"] #5
day_one_max_r[day_one_max_r == "#4B4B4BB2"] <- bsky_col$pm[bsky_col$hex == "#4B4B4BB2"] #6
day_one_max_r[day_one_max_r == "#323232B2"] <- bsky_col$pm[bsky_col$hex == "#323232B2"] #7
day_one_max_r[day_one_max_r == "#191919B2"] <- bsky_col$pm[bsky_col$hex == "#191919B2"] #8
day_one_max_r[day_one_max_r == "#00000000"] <- bsky_col$pm[bsky_col$hex == "#00000000"] #0


# convert to matrix and change values to numeric
day_one_max_m <- matrix(as.numeric(day_one_max_r),
                        nrow = dim(day_one_max_r)[1],
                        ncol = dim(day_one_max_r)[2],
                        byrow = TRUE)

# convert to raster
day_one_max_ras <- raster(day_one_max_m)



# pull extent from grid_info.json
grid_info <- fromJSON(file="gis/grid_info.json")[[1]]


# set extent of raster
extent(day_one_max_ras) <- extent(c(grid_info[1], 
                                    grid_info[3],
                                    grid_info[2],
                                    grid_info[4]))

# same crs as the doc.kml
crs(day_one_max_ras) <- fire_crs[["proj4string"]]


# convert to df object for plotting 
day_one_max_df <- as.data.frame(day_one_max_ras, xy = TRUE) %>% 
  filter(!(is.na(layer))) %>% 
  mutate(layer = factor(layer,
                        levels = c("1", "2", "3", "4", "5", "6", "7", "8")))

# set up google API for ggmap ./md_data/
api <- readLines("./google.api")
register_google(key = api)

# read in fire icon for mapping
fire_icon <- tibble(x = fire_ctds[[1]][1],
                    y = fire_ctds[[1]][2],
                    image = "icons/redFlame.png")


# get plot limits using default ggplot
base_plot <- ggplot() +
  geom_tile(aes(x = x, y = y, fill = layer), data = day_one_max_df)

# get center of plume for offset map
# plume_cen <-c(mean(ggplot_build(base_plot)$layout$panel_scales_x[[1]]$range$range), 
#               mean(ggplot_build(base_plot)$layout$panel_scales_y[[1]]$range$range))

# plume bounding box
plume_bbox <- c(left = ggplot_build(base_plot)$layout$panel_scales_x[[1]]$range$range[1],
                bottom = ggplot_build(base_plot)$layout$panel_scales_y[[1]]$range$range[1],
                right = ggplot_build(base_plot)$layout$panel_scales_x[[1]]$range$range[2],
                top = ggplot_build(base_plot)$layout$panel_scales_y[[1]]$range$range[2])


# pull background map from google
fire_map_info <- get_googlemap(center = c(fire_icon$x, fire_icon$y),
                         maptype = "terrain",
                         zoom = 10,
                         archiving = TRUE,
                         force = FALSE)

# pull background map from open street maps
# fire_map_info <- get_map(location = plume_bbox,
#                                source = "osm",
#                                zoom = 9,
#                                archiving = TRUE,
#                                force = FALSE)






# plot fire map
ggmap(fire_map_info, extent = "device") +
  # smoke trajectory
  geom_tile(aes(x = x, y = y, fill = layer), 
            alpha = 0.6, 
            data = day_one_max_df) +
  scale_fill_manual(values = pm_col_ramp, 
                    name = expression(paste("P", M[2.5], " (", mu, g, "/", m^3, ")", sep = "")),
                    na.value = "transparent") +
  # fire icon
  geom_image(aes(x = x, y = y, image = image), 
             size = 0.03,
             data = fire_icon) 
  



# plot fire map
ggplot() +
  
  # ggmap(fire_map_info, extent = "device") +
  
  # smoke trajectory
  geom_tile(aes(x = x, y = y, fill = layer), 
            # alpha = 0.6, 
            data = day_one_max_df) +
  scale_fill_manual(values = pm_col_ramp, 
                    name = expression(paste("P", M[2.5], " (", mu, g, "/", m^3, ")", sep = "")),
                    na.value = "transparent",
                    limits = levels(layer),
                    drop = FALSE) +
  # title
  # ggtitle("Day one max") +
  
  # legend
  theme(legend.position = "bottom",
        legend.spacing.x = unit(0, "cm")) +
  guides(fill = guide_legend(direction = "horizontal",
                             nrow = 1,
                             label.position = "bottom")) +
  
  # fire icon
  geom_image(aes(x = x, y = y, image = image), 
             size = 0.03,
             data = fire_icon) 

#----------------------------------------------------------------------------





#############################################################################
## archive
#############################################################################


# first opn .kmz in google earth and then save as kml
smoke <- st_read("gis/smoke_dispersion_test.kml")
st_layers("gis/2018_lockridge_day_of_run.kml")

plot(smoke)

library(rgdal)
lyr <- ogrListLayers("gis/smoke_dispersion.kml/doc.kml")



mykml <- readOGR("file.KML","Layer1")

tkml <- getKMLcoordinates(kmlfile="yourkml.kml", ignoreAltitude=T)

ggplot() +
  geom_sf(data = smoke)


list.files("C:/OSGeo4W64/bin/")
dyn.load(x = "C:/OSGeo4W64/bin/gdal300.dll")


# install sf from source after installing gdal using anaconda (install anaconda, open anaconda prompt, run "conda install gdal")

install.packages('sf', type = "source", configure.args=c('--with-gdal-config=/usr/bin/gdal-config-64')) 


smoke <- st_read("gis/smoke_dispersion.kml")


smoke <- readOGR("gis/smoke_dispersion.kmz")

st_drivers()[row.names(st_drivers()) == "LIBKML",]

