
gen_averages_table <- function(desc_vars, comparison_vars, table, buffer, buffer_radius_mi){
  
  summary_table = data.frame(Variable=desc_vars)
  
   # get the national level averages
  
  for (v in 1:length(comparison_vars)) {
    summary_table[v,"Overall (Population Average)"] = sum(table$pop*table[,comparison_vars[v]],na.rm=T)/sum(table$pop,na.rm=T)
  
  }
  
  # get the rural area level averages
  rural <- table %>% filter(rural==1)
  for (v in 1:length(comparison_vars)) {
    summary_table[v,"Rural Areas (Population Average)"] = sum(rural$pop*rural[,comparison_vars[v]],na.rm=T)/sum(rural$pop,na.rm=T)
  }
  
  # get the population weighted averages around the production facilities
  local = table$GEOID %in% unique(buffer$GEOID)
  for (v in 1:length(comparison_vars)) {
    summary_table[v,paste("Within ",buffer_radius_mi," mile(s) of production facility")] = sum(table$pop[local]*table[local,comparison_vars[v]],na.rm=T)/sum(table$pop[local],na.rm=T)
  }
  
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