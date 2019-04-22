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

# load data

landfire <- read_excel("raw_data/landfire_fuels.xlsx")


# calcaulte wtd averages for burns

# Shawnee: White Tract 3-16-2019

white_fuel_wts <- tibble(type = c("TL6", "TL2", "TL3", "GR5", "GR3"),
                         wts = c(0.66, 0.18, 0.05, 0.07, 0.04))

white_fuels <- landfire %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., white_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()
  
  
# Shawnee: Rothomel 3-16-2019
roth_fuel_wts <- tibble(type = c("TL6", "TL2", "TL3", "GR5"),
                         wts = c(0.39, 0.10, 0.15, 0.36))

roth_fuels <- landfire %>%
  filter(type %in% roth_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., roth_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()


# Shawnee: Wolf Creek 3-17-2019
wolf_fuel_wts <- tibble(type = c("TL6", "TL2", "GR1"),
                        wts = c(0.85, 0.13, 0.02))

wolf_fuels <- landfire %>%
  filter(type %in% wolf_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., wolf_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()


# Shawnee: Pine Hills 3-17-2019
pine_fuel_wts <- tibble(type = c("TL6", "TL2", "TL3"),
                        wts = c(0.8, 0.15, 0.05))

pine_fuels <- landfire %>%
  filter(type %in% pine_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., pine_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()


# Shawnee: JOhnson Creek 3-17-2019
jc_fuel_wts <- tibble(type = c("TL6", "TL2", "SB2"),
                        wts = c(0.85, 0.1, 0.05))

jc_fuels <- landfire %>%
  filter(type %in% jc_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., jc_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()


# Shawnee: Kickasola 3-18-2019
kick_fuel_wts <- tibble(type = c("TL6", "TL2", "TL3"),
                      wts = c(0.92, 0.1, 0.07))

kick_fuels <- landfire %>%
  filter(type %in% kick_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., kick_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()


# Shawnee: Pleasant Valley 3-19-2019
plva_fuel_wts <- tibble(type = c("TL6", "TL2", "TL3"),
                        wts = c(0.60, 0.1, 0.3))

plva_fuels <- landfire %>%
  filter(type %in% plva_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., plva_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()



# Shawnee: Russell Cemetery 3-19-2019
russ_fuel_wts <- tibble(type = c("TL6", "TL8"),
                        wts = c(0.85, 0.15))

russ_fuels <- landfire %>%
  filter(type %in% russ_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., russ_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()




# Shawnee: Atwood Ridge 3-22-2019
atw_fuel_wts <- tibble(type = c("TL6", "TL2", "GR1"),
                        wts = c(0.92, 0.03, 0.05))

atw_fuels <- landfire %>%
  filter(type %in% atw_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., atw_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()





# Midewin: Track208 3-23-2019
tr208_fuel_wts <- tibble(type = c("GR8", "GR3"),
                       wts = c(0.90, 0.10))

tr208_fuels <- landfire %>%
  filter(type %in% tr208_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., tr208_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()







# Shawnee: Fink Sandstone 3-27-2019
sand_fuel_wts <- tibble(type = c("TL6", "TL3", "TL2"),
                       wts = c(0.75, 0.20, 0.05))

sand_fuels <- landfire %>%
  filter(type %in% sand_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., sand_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()



# Shawnee: Fink Sandstone 3-27-2019
whoop_fuel_wts <- tibble(type = c("TL6", "TL3", "TL2", "GR1"),
                        wts = c(0.51, 0.27, 0.20, 0.02))

whoop_fuels <- landfire %>%
  filter(type %in% whoop_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., whoop_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()





# Shawnee: Harris Branch 3-28-2019
harris_fuel_wts <- tibble(type = c("TL3", "TL6", "SB1"),
                        wts = c(0.28, 0.44, 0.32))

harris_fuels <- landfire %>%
  filter(type %in% harris_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., harris_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()




# Shawnee: Copperous Branch 3-28-2019
cop_fuel_wts <- tibble(type = c("TL6", "TL3", "TL2"),
                          wts = c(0.5, 0.4, 0.1))

cop_fuels <- landfire %>%
  filter(type %in% cop_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., cop_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()




# Shawnee: IL
il_fuel_wts <- tibble(type = c("TL6", "TL3", "TL2", "GR5", "GR3"),
                       wts = c(0.66, 0.18, 0.05, 0.07, 0.04))

il_fuels <- landfire %>%
  filter(type %in% il_fuel_wts$type) %>% 
  select(type:live_woody, fuel_bed_depth_ft) %>% 
  gather(var, val, hr_1:fuel_bed_depth_ft) %>% 
  left_join(., il_fuel_wts, by = "type") %>% 
  group_by(var) %>% 
  summarise(wt_mean = weighted.mean(val, wts)) %>% 
  ungroup()








