

write_table <- function(facility_demo_table, table_name) {
  
  file_path_to_write <- paste0("output/facility_data/" + table_name + ".xlsx")
  
  write.xlsx(facility_demographics, file_path_to_write, overwrite = TRUE)
  
}