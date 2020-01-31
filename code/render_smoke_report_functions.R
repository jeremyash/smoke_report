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
library(here)

## PLOTTING
library(scales)
library(units)
library(viridis)
library(extrafont)
library(gtable)
library(grid)
#----------------------------------------------------------------------------



#############################################################################
## FUNCTIONS TO RENDER SMOKE REPORT
#############################################################################

##-------------
## create standard directory for new project
##-------------

create_md_dir <- function(YYYY_FOREST_BURN) {
  
  # primary directory
  proj <- paste("md/", YYYY_FOREST_BURN, sep = "")
  
  # sub-directories
  # sub_dir <- paste(proj, c("day_before",
  #                          "day_of",
  #                          "day_before/smoke_dispersion_files",
  #                          "day_of/smoke_dispersion_files"),
  #                  sep = "/")
  
  sub_dir <- paste(proj, c("day_before",
                           "day_of"),
                   sep = "/")
  
    # create the project directories
  lapply(c(proj, sub_dir), function(x) {dir.create(x)})
  
  # message about creation
  message(paste(basename(proj), "has been created"))
}





##-------------
## create firepoker link
##-------------


fp_url <- function(LAT, LON) {
  
  # fire location
  fire_loc <- tibble(lon = LON, 
                     lat = LAT)
  
  # specify coordinates
  coordinates(fire_loc) <- c("lon", "lat")
  proj4string(fire_loc) <- CRS("+init=epsg:4326")
  
  # transform to bbox CRS
  fire_loc_3857 <- spTransform(fire_loc, CRS("+init=epsg:3857"))@coords
  
  # bbox data: xmin, ymin, xmax, ymax
  # bbox_ctds <- c(fire_loc_3857[1] + -1016307,
  #                fire_loc_3857[2] - 489197,
  #                fire_loc_3857[1] - -1016307,
  #                fire_loc_3857[2] + 489197)
  
  
  
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
                  "&clat=38.967&clon=-97.267&zoom=7.000&bbox=[-16540299.098,2518065.675,-5115162.882,6915872.719]&layers=USStates|ForecastDot|Domain|SurfaceFronts|Radar|&fwf=F&dispersion=",
                  paste(0, 
                        disp_brkpts[2], 
                        disp_brkpts[3],
                        disp_brkpts[4],
                        disp_brkpts[5],
                        sep = ","),
                  "&ndfd=WindGust&nohelp=t#",
                  sep = "")
  
  # print(fp_url)
  browseURL(fp_url, browser = "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe",
            encodeIfNeeded = FALSE)
}


##-------------
## function to move firepoker image from downloads to project folder
##-------------
fp_png_to_burn_dir_fun <- function(BURN_DIR, MODEL_RUN) {
  
  # extract  top level directory info
  user_dir <- here()
  
  # create downoad directory path 
  download_dir <- paste(str_split(user_dir, "/")[[1]][1],
                        str_split(user_dir, "/")[[1]][2],
                        str_split(user_dir, "/")[[1]][3],
                        "Downloads",
                        sep = "/")
  
  # find most recently downloaded file, assuming this is the Firepoker PNG
  download_files <- file.info(list.files(download_dir, full.names = TRUE))
  rec_file <- rownames(download_files)[which.max(download_files$mtime)]
   
  # move and rename to appropriate directory
  file.rename(rec_file, 
              paste(user_dir, 
                    "/md/",
                    BURN_DIR,
                    "/",
                    MODEL_RUN,
                    "/firepoker.PNG", sep = ""))
}


##-------------
## function to create smoke report
##-------------

 
render_smoke_report <- function(md_path, burn_name, contact_info, burn_date, lat, lon, model_run, run_id_url, mon_radius){
  # libraries needed
  require(rmarkdown)
  require(tidyverse)
  require(lubridate)
  
  # intermediate file names
  smoke_report_title <- str_replace_all(paste(burn_name, model_run), " ", "_")
  yearmonday <- str_replace_all(Sys.Date(), "-", "")
  
  
  # create html output
  render(input = "code/smoke_template.Rmd",
         output_dir = paste("md/", md_path, "/", model_run, sep = ""),
         output_file = paste(yearmonday,
                             "_",
                             smoke_report_title, ".html", sep = ""), 
         params = list(BURN_NAME = burn_name,
                       CONTACT_INFO = contact_info,
                       BURN_DATE = burn_date,
                       LAT = lat,
                       LON = lon,
                       MODEL_RUN = model_run,
                       RUN_ID_URL = run_id_url,
                       MD_PATH = md_path,
                       MON_RADIUS = mon_radius)) 
}

