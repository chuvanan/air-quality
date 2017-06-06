

## -----------------------------------------------------------------------------
## import data

setwd("~/Downloads/air-quality-index/")
source("./Rscripts/helper-funs.R")

aq2015.12 <- read.csv("./data/Hanoi_PM2.5_2015_12_MTD.csv", stringsAsFactors = FALSE)
aq2016.12 <- read.csv("./data/Hanoi_PM2.5_2016_12_MTD.csv", stringsAsFactors = FALSE)
aq2017.06 <- read.csv("./data/Hanoi_PM2.5_2017_06_MTD.csv", stringsAsFactors = FALSE)
aq2016 <- read.csv("./data/Hanoi_PM2.5_2016_YTD.csv", stringsAsFactors = FALSE)
aq2017 <- read.csv("./data/Hanoi_PM2.5_2017_YTD.csv", stringsAsFactors = FALSE)

## -----------------------------------------------------------------------------
## clean data


## keep identical columns in each data set

names(aq2015.12) <- c("site", "parameter", "date", "year", "month", "day",
                      "hour", "aqi", "unit", "duration", "qc_name")

## identical(names(aq2016), names(aq2016.12))

aq2016 <- rbind(aq2016, aq2016.12)

aq2016 <- aq2016[, c("Site", "Parameter", "Date..LT.", "Year", "Month",
                     "Day", "Hour", "AQI", "AQI.Category", "Conc..Unit",
                           "Duration", "QC.Name")]

names(aq2016) <- c("site", "parameter", "date", "year", "month", "day",
                   "hour", "aqi", "aqi_categ", "unit", "duration", "qc_name")

## identical(names(aq2017), names(aq2017.06))

aq2017 <- rbind(aq2017, aq2017.06)

aq2017 <- aq2017[, c("Site", "Parameter", "Date..LT.", "Year", "Month",
                     "Day", "Hour", "AQI", "AQI.Category", "Conc..Unit",
                           "Duration", "QC.Name")]

names(aq2017) <- c("site", "parameter", "date", "year", "month", "day",
                   "hour", "aqi", "aqi_categ", "unit", "duration", "qc_name")

## decode missing values (-999)

aq2015.12[] <- lapply(aq2015.12, to_NA)
aq2016[] <- lapply(aq2016, to_NA)
aq2017[] <- lapply(aq2017, to_NA)

## standardize aqi category

aq2015.12$aqi <- as.double(aq2015.12$aqi)
aq2015.12$aqi_categ <- vapply(aq2015.12$aqi, categorizeAQI, "1")

aq2016$aqi <- as.double(aq2016$aqi)
aq2016$aqi_categ <- vapply(aq2016$aqi, categorizeAQI, "1")

aq2017$aqi <- as.double(aq2017$aqi)
aq2017$aqi_categ <- vapply(aq2017$aqi, categorizeAQI, "1")


## combine them all

aq2015.12 <- aq2015.12[, names(aq2016)]

air.quality <- do.call("rbind", list(aq2015.12, aq2016, aq2017))

## remove invalid records

air.quality <- air.quality[air.quality$qc_name == "Valid", ]


## format date (adhoc)

air.quality$date <- as.POSIXct(air.quality$date, format = "%Y-%m-%d %I:%M %p")

air.quality$date[4790] <- as.POSIXct("2016-03-13 02:00:00")
air.quality$date[10492] <- as.POSIXct("2016-03-12 02:00:00")

## -----------------------------------------------------------------------------
## export data

write.csv(air.quality, "./data/air-quality.csv", row.names = FALSE)
