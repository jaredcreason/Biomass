
# merge_acs.R


merge_acs <- function(acs_dataset, nata_dataset, places_dataset){
  
  
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
  

  acs_health_data <- acs_health_data %>% left_join(nata_dataset,by=c("Tract"="Tract"))
  acs_health_data <- acs_health_data %>% left_join(places_dataset,by=c("Tract"="Tract"))
  

  return(acs_health_data)
  
}



merge_nata <- function(ats_cancer, ats_resp, places_dataset){
  
  nata_data_merged <- left_join(ats_cancer, ats_resp, by = 'Tract')
  nata_data_merged <- nata_data_merged %>% left_join(places_dataset,by=c("Tract"="Tract"))
  
  
  # rearrange tibble column
  
  nata_data <- nata_data_merged %>% 
    select(
      1:7,
      ncol(nata_data_merged),
      everything()
    )
}





