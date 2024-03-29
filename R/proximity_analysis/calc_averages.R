
gen_summary_means_table_natl <- function(desc_vars,
                                         comparison_vars,
                                         natl_table){
  
  summary_table = data.frame(Variable=desc_vars)
  
  #######################################################################
  
  summary_table$Natl_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(natl_table[[var]], natl_table$pop, na.rm = TRUE)
  })
  
  
  
  rural <- natl_table %>% filter(rural == 1)
  
  summary_table$Natl_Rural_Average <- sapply(comparison_vars, function(var) {
    
    weighted.mean(rural[[var]], rural$pop, na.rm = TRUE)
  })
  
  return(summary_table)
  
  # urban <- natl_table %>% filter(rural == 0)
  
  #  summary_table$Natl_Urban_Average <- sapply(comparison_vars, function(var) {
  
  #   weighted.mean(urban[[var]], urban$pop, na.rm = TRUE)
  #  })
}


#######################################################################




#######################################################################


gen_summary_means_table_buffer <- function(desc_vars,
                                           comparison_vars,
                                           fac_dem_table,
                                           buffer_radius) {
  
  buffer_col_name <- paste('Facility_Buffer_Average_',buffer_radius,'mi', sep ='')
  summary_table = data.frame(Variable=desc_vars)
  
  summary_table[[buffer_col_name]] <- sapply(comparison_vars, function(var) {
    
    weighted.mean(fac_dem_table[[var]], fac_dem_table$pop, na.rm = TRUE)
  })
  
  return(summary_table)
  
}



######################


merge_summary_tables <- function(summary_table_natl, summary_buffer_tables) {
  merged_table <- summary_table_natl
  
  for (buffer_table in summary_buffer_tables) {
    
    merged_table <- left_join(merged_table, buffer_table)
    
  }
  
  return(merged_table)
}



##############################################################################


gen_summary_sd_table_natl <- function(desc_vars,
                              comparison_vars,
                              natl_table){
  
  summary_table = data.frame(Variable=desc_vars)
  
  #######################################################################
  
  summary_table$Natl_SD <- sapply(comparison_vars, function(var) {
    
    x <- natl_table[[var]]
    w <- natl_table$pop
    w_mean <- sum(x * w, na.rm = TRUE) / sum(w, na.rm = TRUE)
    sqrt(sum(w * (x - w_mean)^2, na.rm=TRUE) / sum(w, na.rm = TRUE))
  })
  
  
  
  rural <- natl_table %>% filter(rural==1)
  
  summary_table$Natl_Rural_SD <- sapply(comparison_vars, function(var) {
    
    x <- rural[[var]]
    w <- rural$pop
    w_mean <- sum(x * w, na.rm = TRUE) / sum(w, na.rm = TRUE)
    sqrt(sum(w * (x - w_mean)^2, na.rm=TRUE) / sum(w, na.rm = TRUE))
  })
  
  return(summary_table)
  
 # urban <- natl_table %>% filter(rural == 0)
  
#  summary_table$Natl_Urban_Average <- sapply(comparison_vars, function(var) {
    
 #   weighted.mean(urban[[var]], urban$pop, na.rm = TRUE)
#  })
}
  
  

  gen_summary_sd_table_buffer <- function(desc_vars,
                                             comparison_vars,
                                             fac_dem_table,
                                             buffer_radius) {
    
    buffer_col_name <- paste('Facility_Buffer_SD_',buffer_radius,'mi', sep ='')
    summary_table = data.frame(Variable=desc_vars)
  
  summary_table[[buffer_col_name]] <- sapply(comparison_vars, function(var) {
    
    x <- fac_dem_table[[var]]
    w <- fac_dem_table$pop
    w_mean <- sum(x * w, na.rm = TRUE) / sum(w, na.rm = TRUE)
    sqrt(sum(w * (x - w_mean)^2, na.rm=TRUE) / sum(w, na.rm = TRUE))
    })

  return(summary_table)
  
  }

  

  ######################
  
  
  

  
