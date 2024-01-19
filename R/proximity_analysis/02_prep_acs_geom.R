
gen_acs_data_ct <- function(acs_data) {
  
  data_ct <- acs_data %>% mutate(Tract=substr(GEOID,1,11))
  
  return(data_ct)
}


prep_acs_geometry <- function(data_ct, urban_tracts) {
  

  shp = data_ct %>%
    filter(variable=="pop") %>%
    select(GEOID,Tract) %>%
    arrange(GEOID) %>%
    st_transform(3488)
  
  
  #shp_rural <- shp %>% mutate(rural = fifelse(Tract %in% urban_tracts$Tract,0,1))
  
  sq_miles <- shp %>% mutate(sq_miles = units::set_units(st_area(shp),"mi^2")) %>%
  select(GEOID,sq_miles)
  
  units(sq_miles$sq_miles) <- NULL
  
  # prepare for merge with data
  sq_miles %<>% st_set_geometry(NULL) %>% as.data.table() %>% setkey('GEOID')
  

  return(shp)
  
}