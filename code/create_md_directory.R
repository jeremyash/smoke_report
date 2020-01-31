########################################
## functions
########################################

# create standard directory for new project

create_md_dir <- function(YYYY_FOREST_BURN) {
  
  # primary directory
  proj <- paste("md/", YYYY_FOREST_BURN, sep = "")
  
  # sub-directories
  sub_dir <- paste(proj, c("day_before",
                           "day_of"),
                   sep = "/")
  
  # create the project directories
  lapply(c(proj, sub_dir), function(x) {dir.create(x)})
  
  # message about creation
  message(paste(basename(proj), "has been created"))
}



#----------------------------------------------------------------------------

########################################
## run the functions
########################################

create_md_dir("2020_monongahela_testing")