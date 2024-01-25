
gen_summary_means_table <- function(desc_vars,
                              comparison_vars,
                              natl_table,
                              state_table,
                              fac_dem_table){
  
  summary_table = data.frame(Variable=desc_vars)
  
  #######################################################################
  
  summary_table$Natl_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(natl_table[[var]], natl_table$pop, na.rm = TRUE)
  })
  
  
  
  rural <- natl_table %>% filter(rural == 1)
  
  summary_table$Natl_Rural_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(rural[[var]], rural$pop, na.rm = TRUE)
  })
  
  urban <- natl_table %>% filter(rural == 0)
  
  summary_table$Natl_Urban_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(urban[[var]], urban$pop, na.rm = TRUE)
  })

  
  
  #######################################################################
  
  
  summary_table$State_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(state_table[[var]], state_table$pop, na.rm = TRUE)
  })
  
  rural_state <- state_table %>% filter(rural == 1)
  
  summary_table$State_Rural_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(rural_state[[var]], rural_state$pop, na.rm = TRUE)
  })
  
  urban_state <- state_table %>% filter(rural == 0)
  
  summary_table$State_Urban_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(urban_state[[var]], urban_state$pop, na.rm = TRUE)
  })
  
  
  #######################################################################
  

  summary_table$Facility_Buffer_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(fac_dem_table[[var]], fac_dem_table$pop, na.rm = TRUE)
  })
  

  
return(summary_table)
}


############################################

gen_summary_sd_table <- function(desc_vars,
                              comparison_vars,
                              natl_table,
                              state_table,
                              fac_dem_table){
  
  summary_table = data.frame(Variable=desc_vars)
  
  #######################################################################
  
  
  
  
  summary_table$Natl_SD <- sapply(comparison_vars, function(var) {
    sd(natl_table[[var]], na.rm = TRUE)
  })
  
  #######################################################################
  
  

  summary_table$State_SD <- sapply(comparison_vars, function(var) {
    sd(state_table[[var]], na.rm = TRUE)
  })
  
  #######################################################################
  
  
  summary_table$Facility_Buffer_SD <- sapply(comparison_vars, function(var) {
    
    sd(fac_dem_table[[var]], na.rm = TRUE)
    
  })
  
  
  return(summary_table)
}

