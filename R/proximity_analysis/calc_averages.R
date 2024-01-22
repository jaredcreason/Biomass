
gen_averages_table <- function(desc_vars, comparison_vars, table, buffer, buffer_radius_mi){
  
  summary_table = data.frame(Variable=desc_vars)
  

  summary_table$Population_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(table[[var]], table$pop, na.rm = TRUE)
  })
  
  
  
  rural <- table %>% filter(rural == 1)
  
  summary_table$Rural_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(rural[[var]], rural$pop, na.rm = TRUE)
  })
  
  urban <- table %>% filter(rural == 0)
  
  summary_table$Urban_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(urban[[var]], urban$pop, na.rm = TRUE)
  })
  
  
  summary_table$Population_SD <- sapply(comparison_vars, function(var) {
    sd(table[[var]], na.rm = TRUE)
  })
  
  
return(summary_table)
}



################################
##################################



gen_std_devs_table <- function(desc_vars, comparison_vars, table, buffer, buffer_radius_mi) {
  
  summary_table_sd = data.frame(Variable=desc_vars)
  
  for (v in 1:length(comparison_vars)) {
    a = (table$pop*table[,comparison_vars[v]])/table$pop
    summary_table_sd[v,"Overall (Population Average) SD"] = sqrt(sum((a-mean(a, na.rm=TRUE))^2/(length(a)-1), na.rm=TRUE))
  }
  
  # get the rural area level std devs
  rural <- table %>% filter(rural==1)
  for (v in 1:length(comparison_vars)) {
    a = (rural$pop*rural[,comparison_vars[v]])/rural$pop
    summary_table_sd[v,"Rural Areas (Population Average) SD"] = sqrt(sum((a-mean(a, na.rm=TRUE))^2/(length(a)-1), na.rm=TRUE))
  }
  
  # get the population weighted SD around the production facilities
  local = table$GEOID %in% unique(buffer$GEOID)
  for (v in 1:length(comparison_vars)) {
    a = (table$pop[local]*table[local,comparison_vars[v]])/table$pop[local]
    summary_table_sd[v,paste("Within ",buffer_radius_mi," mile(s) of production facility SD")] = sqrt(sum((a-mean(a, na.rm=TRUE))^2/(length(a)-1), na.rm=TRUE))
  }
  
  return(summary_table_sd)
}