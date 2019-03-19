library(rmarkdown)
library(tidyverse)



# render smoke template for given fire

render("md/2019_XXNF_fire_name/smoke_template.Rmd",
       output_dir = "md/2019_XXNF_fire_name/smoke_reports",
       output_file = "fire_name_day_before.html", 
       params = list(FIRE_NAME = "Test",
                     AUTHOR = "Jeremy Ash",
                     LAT = 38.144167,
                     LON = -79.939722,
                     FIRE_DATE = "March xx, 2019"))


# 2019 shawnee white tract
render("md/2019_shawnee_white_tract/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_white_tract/smoke_reports",
       output_file = "white_tract_day_of.html", 
       params = list(FIRE_NAME = "White Tract",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.81809,
                     LON = -89.46695))

# 2019 shawnee rothomel
render("md/2019_shawnee_rothomel/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_rothomel/smoke_reports",
       output_file = "rothomel_day_of.html", 
       params = list(FIRE_NAME = "Rothomel Tract",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.30257,
                     LON = -88.62219))



# 2019 shawnee pine hills
render("md/2019_shawnee_pine_hills/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_pine_hills/smoke_reports",
       output_file = "pine_hills_day_of.html", 
       params = list(FIRE_NAME = "Pine Hills",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.566,
                     LON = -89.438))


# 2019 shawnee wolf creek
render("md/2019_shawnee_wolf_creek/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_wolf_creek/smoke_reports",
       output_file = "wolf_creek_day_of.html", 
       params = list(FIRE_NAME = "Wolf Creek",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.204816,
                     LON = -89.350101))


# 2019 shawnee johnson creek
render("md/2019_shawnee_johnson_creek/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_johnson_creek/smoke_reports",
       output_file = "johnson_creek_day_of.html", 
       params = list(FIRE_NAME = "Johnson Creek",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.83361,
                     LON = -89.51884))


# 2019 shawnee kickasola
render("md/2019_shawnee_johnson_creek/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_kickasola/smoke_reports",
       output_file = "kickasola_day_of.html", 
       params = list(FIRE_NAME = "Kickasola",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.17507,
                     LON = -88.49055))



# 2019 shawnee russell cemetery
render("md/2019_shawnee_russell_cemetery/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_russell_cemetery/smoke_reports",
       output_file = "russell_cemetery_day_of.html", 
       params = list(FIRE_NAME = "Russell Cemetery",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.595120,
                     LON = -88.305130))


# 2019 shawnee kickasola unit 1
render("md/2019_shawnee_kickasola_unit1/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_kickasola_unit1/smoke_reports",
       output_file = "kickasola_unit1_day_of.html", 
       params = list(FIRE_NAME = "Kickasola Unit 1",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.17507,
                     LON = -88.49055))


# 2019 shawnee kickasola unit 1
render("md/2019_shawnee_pleasant_valley_subunit2/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_pleasant_valley_subunit2/smoke_reports",
       output_file = "pleasant_valley_subunit2_day_of.html", 
       params = list(FIRE_NAME = "Pleasant Valley Subunit 2",
                     AUTHOR = "Jeremy Ash",
                     LAT = 37.41591,
                     LON = -88.54618))


#----------------------------------------------------------------------------

#############################################################################
## now with updated smoke template
#############################################################################

# 2019 shawnee wolf creek test
render("md/2019_shawnee_wolf_creek_test/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_wolf_creek_test/smoke_reports",
       output_file = "wolf_creek_test_day_of.html", 
       params = list(FIRE_NAME = "Wolf Creek",
                     AUTHOR = "Jeremy Ash",
                     FIRE_DATE = "March 19, 2019",
                     LAT = 37.204816,
                     LON = -89.350101,
                     MODEL_RUN = "day of")) # needs to be "day before" or "day of"

render("md/2019_shawnee_wolf_creek_test/smoke_template.Rmd",
       output_dir = "md/2019_shawnee_wolf_creek_test/smoke_reports",
       output_file = "wolf_creek_test_day_before.html", 
       params = list(FIRE_NAME = "Wolf Creek",
                     AUTHOR = "Jeremy Ash",
                     FIRE_DATE = "March 19, 2019",
                     LAT = 37.204816,
                     LON = -89.350101,
                     MODEL_RUN = "day before"))



















