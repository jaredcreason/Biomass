

add_comp_vars <- function(fac_dem_table) {
  
  fac_dem_clean <- fac_dem_table %>%
    filter(pop > 0) %>%
    filter(hispanic_denominator > 0) %>%
    drop_na()
  
  
  fac_dem_with_comp_vars <- fac_dem_clean %>%
    mutate(white_pct=(white/pop)*100,
           minority_black=(black/pop)*100,
           minority_other=((pop-(white + black))/pop)*100,
           minority_hispanic=(hispanic/hispanic_denominator)*100)
           # pov99=pov99/pop*100,
           # pov50=pov50/pop*100,
           # income=income)
  
  
  return(fac_dem_with_comp_vars)
  
  
  }