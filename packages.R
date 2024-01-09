
# R/packages.R


# This function will check if a package is installed, and if not, install it
pkgTest <- function(x) {
  if (!require(x, character.only = TRUE))
  {
    install.packages(x, dep = TRUE)
    if(!require(x, character.only = TRUE)) stop("Package not found")
  }
}

## These lines load the required packages
packages <- c('tidycensus',
              'tigris',
              'tidyverse',
              'magrittr',
              'data.table',
              'sf',
              'foreach',
              'doSNOW',
              'scales',
              'odbc',
              'colorspace',
              'openxlsx',
              'here',
              'readxl',
              'openxlsx',
              'usmap',
              'leaflet',
              'writexl',
              'htmlwidgets') ## you can add more packages here
lapply(packages, pkgTest)

library(usmap)
library(ggplot2)
 library(stringr)


#load_required_packages <- function() {
 # library(targets)
  #library(tarchetypes)
  #library(tidycensus)
  #library(tigris)
  #library(tidyverse)
  #library(magrittr)
  #library(data.table)
  #library(sf)
  #library(foreach)
  #library(doSNOW)
  #library(scales)
  #library(odbc)
  #library(colorspace)
  #library(openxlsx)
  #library(openxlsx)
  #library(usmap)
  #library(leaflet)
  #library(leafdown)
  #library(shiny)
  #library(shinydashboard)
  #library(htmlwidgets)
#}