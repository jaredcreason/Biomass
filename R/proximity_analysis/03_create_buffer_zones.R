

create_buffer_zone <- function(facilities_map, radius_mi, shp) {
  
  
  communities = st_buffer(facilities_map, dist=radius_mi*1609.34) 
  
  
  buffer = st_intersection(communities,shp) %>%
    select(GEOID,Tract,Label)
  
  
  # # get GEOID to facility list
  #facility_buffer <- st_intersection(facilities_map, buffer) %>% select(Label, GEOID) %>% st_set_geometry(NULL)

  return(buffer)
}