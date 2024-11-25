
# merge_acs.R


merge_acs <- function(acs_dataset, health_dataset){
  
  
  data_ct <-acs_dataset %>%
    mutate(Tract=substr(GEOID,1,11))

  
  acs_health_data <- data_ct %>%
    pivot_wider(names_from='variable',values_from='estimate') %>% 
    mutate(white_pct=(white/pop)*100,
           minority_black=(black/pop)*100,
           minority_hispanic=(hispanic/hispanic_denominator)*100,
           minority_other=((pop-(white + black))/pop)*100,
           pov99=pov99/pop*100,
           pov50=pov50/pop*100,
           income=income/1000)
  

  acs_health_data <- acs_health_data %>% left_join(health_dataset,by=c("Tract"="Tract"))
  #acs_health_data <- acs_health_data %>% left_join(places_dataset,by=c("Tract"="Tract"))
  

  return(acs_health_data)
  
}



merge_health <- function(ats_2020_cancer_loaded, ats_resp_loaded, places_cancer_loaded, places_asthma_loaded, places_chd_loaded){
  nata_data_merged <- ats_2020_cancer_loaded
  #nata_data_merged <- left_join(ats_2020_cancer_loaded, ats_resp_loaded, by = 'Tract')
  health_data_merged <- nata_data_merged %>% left_join(places_cancer_loaded,by="Tract") %>%
    left_join(places_asthma_loaded,by="Tract")%>%
    left_join(places_chd_loaded,by="Tract")
  #%>% left_join(places_health_ins,by=c("Tract"="Tract"))
  
  
  # rearrange tibble column
  
  # health_data_merged <- health_data_merged %>% 
  #   select(
  #     1:6,
  #     ncol(health_data_merged),
  #     everything()
  #   )
  
  return(health_data_merged)
}





