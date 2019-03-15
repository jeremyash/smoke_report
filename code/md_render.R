library(rmarkdown)
library(tidyverse)



# render smoke template for given fire

render("md/2019_XXNF_fire_name/smoke_template.Rmd",
       output_dir = "md/2019_XXNF_fire_name/smoke_reports",
       output_file = "fire_name_day_before.html", 
       params = list(FIRE_NAME = "Test",
                     AUTHOR = "Jeremy Ash",
                     LAT = 38.144167,
                     LON = -79.939722))


