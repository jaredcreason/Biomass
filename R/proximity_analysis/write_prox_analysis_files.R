

write_summary_means_table <- function(summary_table, final_table_name, output_dir = 'output/summary_tables') {
  
  
  filepath <- file.path(output_dir, paste0(final_table_name, '_means_summary.xlsx'))
  
  write.xlsx(summary_table, filepath)  
}



write_summary_sd_table <- function(summary_table, final_table_name, output_dir = 'output/summary_tables') {
  
  
  filepath <- file.path(output_dir, paste0(final_table_name, '_sd_summary.xlsx'))
  
  write.xlsx(summary_table, filepath)  
}

