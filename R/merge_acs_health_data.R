
# create_table_2.R


create_table_2 <- function(data, cancer_data, resp_data){
  
  
  data_ct <-data %>% mutate(Tract=substr(GEOID,1,11))
  
#  shp <- data_ct %>%
 #   filter(variable=="pop") %>%
  #  select(GEOID,Tract) %>%
   # arrange(GEOID) %>%
    #st_transform(3488)
  
  #tr <- readRDS("data/tr.rds")
  
  # tr = shp %>% group_by(Tract) %>% summarize(geometry=st_union(geometry))
  # saveRDS(tr, "data/tr.rds")
  
  #tr_pts <- tr %>% st_centroid()
  
  ###### THIS STEP TAKES TIME
  ## identify rural and urban geoid
  
  #urban_tracts <- readRDS("data/urban_tracts.rds")
  
  
  #sq_miles <- shp %>% mutate(sq_miles = units::set_units(st_area(shp),"mi^2")) %>%
   # select(GEOID,sq_miles)
  
  #units(sq_miles$sq_miles) <- NULL
  
 # sq_miles %<>% st_set_geometry(NULL) %>% as.data.table() %>% setkey('GEOID')
  #table_full <- data_ct %>% 
   # st_set_geometry(NULL) %>%
    #as.data.table() %>% 
    #setkey('GEOID')
  
  #table_1 <- table_full[sq_miles]
  
  acs_health_data <- data_ct %>%
    pivot_wider(names_from='variable',values_from='estimate') %>%
    mutate(white_pct=(white/pop)*100,
           minority_black=(black/pop)*100,
           minority_other=((pop-(white + black))/pop)*100,
           minority_hispanic=(hispanic/hispanic_denominator)*100,
           pov99=pov99/pop*100,
           pov50=pov50/pop*100,
           income=income/1000) %>%
    left_join(cancer_dta,by=c("Tract"="Tract")) %>%
    left_join(resp_dta,by=c("Tract"="Tract")) %>%
    as.data.table() %>%
    setkey('GEOID')
  
  return(acs_health_data)
  
}
















