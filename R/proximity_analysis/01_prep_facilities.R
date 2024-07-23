

gen_uac <- function(urban_areas) {
  uac <- urban_areas %>% st_transform(3488)
  return(uac)
}


gen_fac_lat_lon <- function(facilities) {
  facs_infer_latlon <- EJAM::latlon_any_format(facilities)
  
  facilities_lat_lon <- facs_infer_latlon %>%
    select(lon,
           lat,
           Label) %>%
    distinct()
  
  return(facilities_lat_lon)
}


##


gen_fac_sf <- function(facilities){
  facs_infer_latlon <- EJAM::latlon_any_format(facilities) %>%
    select(Label, lon, lat)
  facilities_sf = st_as_sf(facs_infer_latlon, 
                           coords=c(x='lon',y='lat'), 
                           crs=4326) %>%
    st_transform(3488) %>% 
    distinct(geometry, .keep_all = TRUE)
  
  return(facilities_sf)
}

###


gen_fac_sf_urban <- function(facilities_sf, uac) {
  
  facilities_sf_urban <- st_intersection(facilities_sf,uac) %>%
    mutate(rural = 0)
  
  return(facilities_sf_urban)
}


gen_fac_sf_rural <- function(fac_sf, fac_sf_urban){
  facilities_sf_rural <- fac_sf %>%
    mutate(rural = ifelse(Label %in% unique(fac_sf_urban$Label),0,1)) %>%
    as.data.frame() %>%
    select(rural,Label)
  
  return(facilities_sf_rural)
}


gen_fac_map <- function(facilities_sf, facilities_sf_rural, facilities_lat_lon) {
  
  facilities_map <- facilities_sf %>%
    left_join(facilities_sf_rural, by = "Label") %>%
    left_join(facilities_lat_lon, by = "Label") %>%
    distinct()
  
  return(facilities_map)
  
  
  
}
