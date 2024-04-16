
gen_buffer_pop_table <- function(fac_dem_mid) {
  buffer_pop_table <- fac_dem_mid %>% group_by(Label) %>% summarize(buffer_pop = sum(pop))
  
  return(buffer_pop_table)
  }


calc_mean_buffer_pop <- function(buffer_pop_table) {
  buffer_pop_mean <- round(mean(buffer_pop_table$buffer_pop),0)
  return(buffer_pop_mean)
  
}
  

calc_median_buffer_pop <- function(buffer_pop_table) {
  buffer_pop_median <- round(median(buffer_pop_table$buffer_pop),0)
  return(buffer_pop_median)
  
}

