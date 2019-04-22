#############################################################################
## RUN THIS SECTION OF CODE FIRST TO DEVELOP FUNCTION THAT WILL GENERATE SMOKE REPORT
#############################################################################

render_smoke_report <- function(md_path, fire_name, contact_info, fire_date, lat, lon, model_run){
        # libraries needed
        require(rmarkdown)
        require(tidyverse)
        require(lubridate)
        
        # intermediate file names
        smoke_report_title <- str_replace_all(paste(fire_name, model_run), " ", "_")
        yearmonday <- str_replace_all(Sys.Date(), "-", "")
        
        
        # create html output
        render(input = paste("md/", md_path, "/smoke_template.Rmd", sep = ""),
               output_dir = paste("md/", md_path, "/smoke_reports", sep = ""),
               output_file = paste(yearmonday,
                                   "_",
                                   smoke_report_title, ".html", sep = ""), 
               params = list(FIRE_NAME = fire_name,
                             CONTACT_INFO = contact_info,
                             FIRE_DATE = fire_date,
                             LAT = lat,
                             LON = lon,
                             MODEL_RUN = model_run)) 
}

#############################################################################
## APPLY ABOVE FUNCTION TO BURN INFO
#############################################################################


# render smoke template for given fire
render_smoke_report(md_path = "2019_XXNF_fire_name_testing", # update with path for burn
                    fire_name = "TEST", # name of fire
                    contact_info = "Trent Wickman, t...@usda.gov, XXX-XXXX", # full contact info or website
                    fire_date = "April x, 2019", # planned date
                    lat = 43,
                    lon = -90.632,
                    model_run = "day of") # needs to be "day of" or "day before"



#############################################################################
## APRIL 15
#############################################################################


# hoosier jeffries
render_smoke_report(md_path = "2019_hoosier_jeffries", # update with path for burn
                    fire_name = "Jeffries Tract", # name of fire
                    contact_info = "Jeremy Ash, jeremy.ash@usda.gov, 608-234-3300", # full contact info or website
                    fire_date = "April 16, 2019", # planned date
                    lat = 38.173467,
                    lon = -86.480140,
                    model_run = "day of") # needs to be "day of" or "day before"



# hoosier riddle
render_smoke_report(md_path = "2019_hoosier_riddle_copy", # update with path for burn
                    fire_name = "Riddle Tract", # name of fire
                    contact_info = "Jeremy Ash, jeremy.ash@usda.gov, 608-234-3300", # full contact info or website
                    fire_date = "April 16, 2019", # planned date
                    lat = 38.159302,
                    lon = -86.439198,
                    model_run = "day of") # needs to be "day of" or "day before"




