

gen_uac <- function(urban_areas) {
  uac <- urban_areas %>% st_transform(3488)
  return(uac)
}


gen_fac_lat_lon <- function(facility_data, latitude_col_name, longitude_col_name) {
  
  facilities <- facility_data %>%
    
    select(longitude_col_name,
           latitude_col_name,
           everything())
  
  
  facilities_lat_lon <- facilities %>%
    select(longitude_col_name,
           latitude_col_name,
           Label)
  
  
  
  return(facilities_lat_lon)
  
  
}


##


gen_fac_sf <- function(facility_data, latitude_col_name, longitude_col_name){
  facilities_sf = st_as_sf(facility_data, 
                           coords=c(x=longitude_col_name,y=latitude_col_name), 
                           crs=4326) %>%
    st_transform(3488)
  
  return(facilities_sf)
}

###


gen_fac_sf_urban <- function(facilities_sf, uac) {
  
  facilities_sf_urban <- st_intersection(facilities_sf,uac) %>%
    mutate(rural = 0)
  
  return(facilities_sf_urban)
}


gen_fac_sf_rural <- function(facilities_sf, facilities_sf_urban){
  facilities_sf_rural <- facilities_sf %>%
    mutate(rural = fifelse(Label %in% unique(facilities_sf_urban$Label),0,1)) %>%
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
