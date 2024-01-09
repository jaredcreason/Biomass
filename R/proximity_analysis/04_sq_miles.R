

gen_sq_miles <- function(shp) {
  
  sq_miles <- shp %>% mutate(sq_miles = units::set_units(st_area(shp),"mi^2")) %>%
    select(GEOID,sq_miles)
  
  units(sq_miles$sq_miles) <- NULL
  
  # prepare for merge with data
  sq_miles %<>% st_set_geometry(NULL) %>% as.data.table() %>% setkey('GEOID')
  
  return(sq_miles)
}