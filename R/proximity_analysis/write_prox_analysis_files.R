

write_summary_means_table <- function(summary_table, final_table_name) {
  
  output_path <- file.path('output', 'summary_tables', paste0(final_table_name,'_means','.xlsx'))
  write.xlsx(summary_table, output_path)  
}


write_summary_std_devs_table <- function(summary_table, final_table_name) {
  
  output_path <- file.path('output', 'summary_tables', paste0(final_table_name,'_standard_deviations','.xlsx'))
  write.xlsx(summary_table, output_path)  
}