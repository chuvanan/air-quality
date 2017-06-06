

setwd("~/Downloads/air-quality-index/")

air <- read.csv("./data/air-quality.csv", stringsAsFactors = FALSE)

names(air)[names(air) == "date"] <- "datetime"
air$datetime <- as.POSIXct(air$datetime)

air$date <- substr(air$datetime, 1, 10)
air$date <- as.Date(air$date)
