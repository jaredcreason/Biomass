# app.R

library(tidyverse)
library(shiny)
library(shinydashboard)
library(sf)
 library(leaflet)
library(leafdown)
library(RColorBrewer)






sf_facilities_al <- st_as_sf(facilities_al, coords = c('Latitude', 'Longitude'), crs = 4326)
sf_facilities_al <- st_transform(sf_facilities_al, crs = 3857)


sf_census_tracts <- st_as_sf(acs_health_geom)
sf_census_tracts <- st_transform(sf_census_tracts, crs = 3857)

acs_health_geom <- st_transform(acs_health_geom, crs=3857)
sf_census_tracts



mymap <- leaflet() %>% 
  addTiles() %>% 
  addPolygons(data = acs_health_geom$geometry,
              fillColor = 'red',
             fillOpacity = 0.5,
             weight = 1) %>%
  
  addCircleMarkers(data = facilities_al, radius = 2, color = 'blue', fillOpacity = .8)

mymap

