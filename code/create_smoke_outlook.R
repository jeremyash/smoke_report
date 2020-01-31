#############################################################################
## FOLLOW NUMBERED STEPS BELOW TO CREATE THE SMOKE OUTLOOK
#############################################################################

##-------------
## 1. SOURCE R CODE WITH FUNCTIONS TO GENERATE DIRECTORY, FIREPOKER LINK AND SMOKE REPORT
##-------------

source("code/render_smoke_report_functions.R")



##-------------
## 2. LIST NAME OF FOLDER WHERE BURN INFO WILL BE STORED, WHICH MODEL RUN THIS IS AND BURN COORDINATES
##-------------

# create directory of burn files in format "YYYY_forest_burnname"
burn_dir <- "YYYY_forest_burnname"
burn_dir <- "2020_monongahela_testing"

# model run: # needs to be "day_before" or "day_of" 
model_run <- "day_before"

# burn lat/long
burn_lat <- 38.7860
burn_lon <- -79.6520



##-------------
## 3. CREATE DIRECTORY TO STORE FILES
##-------------

# create directory for burn
create_md_dir(burn_dir)



##-------------
## 4. CREATE FIREPOKER LINK TO DOWNLOAD PNG OF WEBPAGE
##-------------

fp_url(LAT = burn_lat,
       LON = burn_lon) # coordinates of planned burn



##-------------
## 5. DOWNLOAD SCREEN CAPTURE OF FIREPOKER
##-------------

# Use Full Page Screen Capture in Chrome to capture met data and download to PNG file. Should download directly to Downloads folder. Move directly to step 6, as it will look for most recently downloaded file. 



##-------------
## 6. MOVE FIREPOKER IMAGE TO CORRECT FOLDER
##-------------

# function will move most recently downloaded file (assuming this is the firepoker img) to burn_dir/model_run and rename it to firepoker.PNG
fp_png_to_burn_dir_fun(burn_dir, model_run)



##-------------
## 5. CREATE SMOKE OUTLOOK
##-------------

# render smoke template for given burn
suppressWarnings( 
  render_smoke_report(md_path = burn_dir, # update with directory created above
                      burn_name = "Test", # name of fire
                      contact_info = "Jeremy Ash, jeremy.ash@usda.gov, 608-234-3300", # full contact info or website
                      burn_date = "January 31, 2020", # planned date
                      lat = burn_lat, # latitude of planned ignition
                      lon = burn_lon, # longitude of planned ignition
                      model_run = model_run, # created above 
                      run_id_url = "https://playground-2.airfire.org/bluesky-web-output/15e2aec893afb9-dispersion/", # click on 'Results Output' the Run ID on top left of BSky Dispersion Results and copy full URL
                      mon_radius = 150 # radius in km around the burn to pull AQI monitors. start with 50 and increase if needed 
  ))
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------


#############################################################################
## FOLLOW NUMBERED STEPS BELOW TO CREATE THE SMOKE OUTLOOK
#############################################################################

##-------------
## 1. SOURCE R CODE WITH FUNCTIONS TO GENERATE DIRECTORY, FIREPOKER LINK AND SMOKE REPORT
##-------------

source("code/render_smoke_report_functions.R")



##-------------
## 2. LIST NAME OF FOLDER WHERE BURN INFO WILL BE STORED, WHICH MODEL RUN THIS IS AND BURN COORDINATES
##-------------

# create directory of burn files in format "YYYY_forest_burnname"
burn_dir <- "YYYY_forest_burnname"


# model run: # needs to be "day_before" or "day_of" 
model_run <- "day_before"

# burn lat/long
burn_lat <- 38.7860
burn_lon <- -79.6520



##-------------
## 3. CREATE DIRECTORY TO STORE FILES
##-------------

# create directory for burn
create_md_dir(burn_dir)



##-------------
## 4. CREATE FIREPOKER LINK TO DOWNLOAD PNG OF WEBPAGE
##-------------

fp_url(LAT = burn_lat,
       LON = burn_lon) # coordinates of planned burn



##-------------
## 5. DOWNLOAD SCREEN CAPTURE OF FIREPOKER
##-------------

# Use Full Page Screen Capture in Chrome to capture met data and download to PNG file. Should download directly to Downloads folder. Move directly to step 6, as it will look for most recently downloaded file. 



##-------------
## 6. MOVE FIREPOKER IMAGE TO CORRECT FOLDER
##-------------

# function will move most recently downloaded file (assuming this is the firepoker img) to burn_dir/model_run and rename it to firepoker.PNG
fp_png_to_burn_dir_fun(burn_dir, model_run)



##-------------
## 5. CREATE SMOKE OUTLOOK
##-------------

# render smoke template for given burn
suppressWarnings( 
  render_smoke_report(md_path = burn_dir, # update with directory created above
                      burn_name = "Test", # name of fire
                      contact_info = "Jeremy Ash, jeremy.ash@usda.gov, 608-234-3300", # full contact info or website
                      burn_date = "January 31, 2020", # planned date
                      lat = burn_lat, # latitude of planned ignition
                      lon = burn_lon, # longitude of planned ignition
                      model_run = model_run, # created above 
                      run_id = "15e2aec893afb9", # the Run ID on top left of BSky Dispersion Results
                      mon_radius = 150 # radius in km around the burn to pull AQI monitors. start with 50 and increase if needed 
  ))
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------
#----------------------------------------------------------------------------














