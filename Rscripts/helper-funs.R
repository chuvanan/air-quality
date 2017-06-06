

to_NA <- function(x) replace(x, x == -999, NA)

categorizeAQI <- function(x) {
    stopifnot(is.double(x))
    if (is.na(x)) return(NA_character_)
    if (x <= 50) return("Good")
    if (x <= 100) return("Moderate")
    if (x <= 150) return("Unhealthy for Sensitive Groups")
    if (x <= 200) return("Unhealthy")
    if (x <= 300) return("Very Unhealthy")
    if (x > 300) return("Hazardous")
}
