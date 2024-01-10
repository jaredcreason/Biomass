

prep_facilities <- function(facility_data, ID_column_name, longitude_col_name, latitude_col_name) {
  
  facilities <- facility_data %>%
    
  #  mutate(Label = ID_column_name) %>%
    
    select(longitude_col_name,
           latitude_col_name,
           everything())
  
  facilities$Label <- facilities[, ID_column_name]
  
  
  facilities_lat_lon <- facilities %>%
    select(longitude_col_name,
           latitude_col_name,
           Label)
  
  facilities_sf = st_as_sf(facilities, 
                           coords=c(x=longitude_col_name,y=latitude_col_name), 
                           crs=4326) %>%
    st_transform(3488)
  
  rm(facilities)
  
  urban_areas <- urban_areas()
  uac <- urban_areas %>% st_transform(3488)
  
  rm(urban_areas)
  
  facilities_sf_urban <- st_intersection(facilities_sf,uac) %>%
    mutate(rural = 0)
  
  rm(uac)
  
  facilities_sf_rural <- facilities_sf %>%
    mutate(rural = fifelse(Label %in% unique(facilities_sf_urban$Label),0,1)) %>%
    as.data.frame() %>%
    select(rural,Label)
  
  facilities_map <- facilities_sf %>%
    left_join(facilities_sf_rural, by = "Label") %>%
    left_join(facilities_lat_lon, by = "Label") %>%
    distinct()
  
  
  return(facilities_map)
  
  
  
}
