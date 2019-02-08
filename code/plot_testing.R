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

library(PWFSLSmoke)
library(MazamaSpatialUtils)
#----------------------------------------------------------------------------

#############################################################################
## function
#############################################################################

ja_monitor_dailyBarplot <- function (ws_monitor, monitorID = NULL, tlim = NULL, minHours = 18, 
          gridPos = "", gridCol = "black", gridLwd = 0.5, gridLty = "solid", 
          labels_x_nudge = 0, labels_y_nudge = 0, ...) 
{
  if (monitor_isEmpty(ws_monitor)) {
    stop("ws_monitor object contains zero monitors")
  }
  if (is.null(monitorID)) {
    if (nrow(ws_monitor$meta) == 1) {
      monitorID <- ws_monitor$meta$monitorID[1]
    }
    else {
      stop(paste0("ws_monitor object contains data for > 1 monitor. Please specify a monitorID from: '", 
                  paste(ws_monitor$meta$monitorID, collapse = "', '"), 
                  "'"))
    }
  }
  if (!is.null(tlim)) {
    if ("POSIXct" %in% class(tlim)) {
      tlimStrings <- strftime(tlim, "%Y%m%d", tz = "UTC")
    }
    else {
      tlimStrings <- as.character(tlim)
    }
    if (stringr::str_length(tlimStrings)[1] == 8) {
      tlimStrings[1] <- paste0(tlimStrings[1], "00")
    }
    if (stringr::str_length(tlimStrings)[2] == 8) {
      tlimStrings[2] <- paste0(tlimStrings[2], "23")
    }
    tlim <- tlimStrings
  }
  timezone <- as.character(ws_monitor$meta[monitorID, "timezone"])
  mon <- monitor_subset(ws_monitor, monitorIDs = monitorID, 
                        tlim = tlim, timezone = timezone)
  mon_dailyMean <- monitor_dailyStatistic(mon, FUN = get("mean"), 
                                          dayStart = "midnight", na.rm = TRUE, minHours = minHours)
  localTime <- mon_dailyMean$data$datetime
  pm25 <- as.numeric(mon_dailyMean$data[, monitorID])
  argsList <- list(...)
  argsList$height <- pm25
  if (!("col" %in% names(argsList))) {
    argsList$col <- aqiColors(pm25)
  }
  if (!("ylab" %in% names(argsList))) {
    argsList$ylab <- expression(paste("PM"[2.5] * " (", mu, 
                                      "g/m"^3 * ")"))
  }
  argsList$las <- 2#ifelse("las" %in% names(argsList), argsList$las, 
                         #1)
  if (!("main" %in% names(argsList))) {
    argsList$main <- expression(paste("Daily Average PM"[2.5]))
  }
  argsList$axes <- ifelse("axes" %in% names(argsList), argsList$axes, 
                          TRUE)
  argsList$space <- ifelse("space" %in% names(argsList), argsList$space, 
                           0.2)
  argsList$cex.names <- ifelse("cex.names" %in% names(argsList), 
                               argsList$cex.names, par("cex.axis"))
  if (gridPos == "under") {
    do.call(barplot, argsList)
    abline(h = axTicks(2)[-1], col = gridCol, lwd = gridLwd, 
           lty = gridLty)
    argsList$add <- TRUE
  }
  do.call(barplot, argsList)
  if (argsList$axes && !("names.arg" %in% names(argsList))) {
    barCount <- length(argsList$height)
    allIndices <- 1:barCount
    allLabels <- strftime(localTime, "%b %d", tz = timezone)
    maxLabelCount <- 16
    stride <- round(barCount/maxLabelCount)
    if (stride == 0) {
      indices <- allIndices
      labels <- allLabels
    }
    else {
      indices <- allIndices[seq(1, barCount, by = stride)]
      labels <- allLabels[seq(1, barCount, by = stride)]
    }
    labels_x <- (indices - 0.5) + (indices * argsList$space)
    labels_y <- -0.06 * (par("usr")[4] - par("usr")[3])
    text(labels_x - labels_x_nudge, labels_y - labels_y_nudge, 
         labels, srt = 45, cex = argsList$cex.names, xpd = NA)
    axis(1, at = labels_x, labels = FALSE, lwd = 0, lwd.ticks = 1)
  }
  if (gridPos == "over") {
    abline(h = axTicks(2)[-1], col = gridCol, lwd = gridLwd, 
           lty = gridLty)
  }
}

#############################################################################
## pull monitors near fire
#############################################################################

# number of previous days
n_hrs <- 96

#rx fire
fire_info <- tibble(longitude = -82.22618525756064, 
                    latitude = 39.53743368404867,
                    name = "Wayne NF Rx Fire")

# pull hourly data within 100 km of rx fire  and the last n_days hours
airnow <- airnow_loadLatest() %>% 
  monitor_subsetByDistance(fire_info$longitude, fire_info$latitude, radius = 100) 

airnow$data <- airnow$data %>% 
  slice(-(1:(n()-n_hrs)))

# 
# # check what the dates are...data are for the previous 10 days on an hourly basis
# airnow_dat <- airnow[["data"]] 
# range(airnow_dat$datetime)

# get number of monitors 
n_mons <- length(unique(airnow$meta$monitorID))


# Monitor Map showing Max HOurly AQI
monitor_esriMap(airnow, 
                centerLon = fire_info$longitude, 
                centerLat = fire_info$latitude,
                zoom = 10,
                width = 600, 
                height = 600, 
                cex = 2)
addIcon('redFlame', fire_info$longitude, fire_info$latitude, expansion = .0008)
text(fire_info$longitude, fire_info$latitude, fire_info$name, pos = 3, cex = .8, col = "firebrick4")
addAQILegend(title = "Max AQI Level", pt.cex = 1.5)


# Daily time series
layout(matrix(seq(n_mons)))
par(mar=c(1,1,3,1))
for (monitorID in unique(airnow$meta$monitorID)) {
  siteName <- airnow$meta[monitorID,'siteName']
  ja_monitor_dailyBarplot(airnow, monitorID=monitorID, main=siteName) 
}
# addAQILegend(fill = rev(AQI$colors), pch = NULL)





# calculate mean and prep data for plotting
mon_dailyMean_list <- monitor_dailyStatistic(airnow, FUN = get("mean"), 
                                        dayStart = "midnight", 
                                        na.rm = TRUE, 
                                        minHours = 18)

mon_names <- mon_dailyMean_list[[1]]$siteName

mon_mean_df <- mon_dailyMean_list[[2]] 
colnames(mon_mean_df)[2:(2+length(mon_names)-1)] <- mon_names
mon_mean_df <- mon_mean_df %>% 
  gather(mon_name, pm_val, -1) %>% 
  mutate(aqi_col = aqiColors(pm_val),
         aqi_cat = cut(pm_val, 
                       breaks = AQI$breaks_24,
                       labels = AQI$names))



ggplot(aes(x = datetime, y = pm_val, group = mon_name), data = mon_mean_df) +
  geom_bar(aes(fill = aqi_cat), stat = "identity", show.legend = FALSE) +
  scale_fill_manual(values = AQI$colors) +
  facet_wrap(~mon_name, ncol = 1) +
  labs(y = expression(PM[2.5]), x = NULL) +
  theme_minimal()


ggsave("figures/wayne_aqi_ggplot.pdf",
       height = 4,
       width = 4)




logger.setup()

tbl <- airnow_downloadParseData("PM2.5", 2016070112, hours=24)

#############################################################################
## location map
#############################################################################

code


REVIEW LOCAL NOTEBOOKS ON GITHUB