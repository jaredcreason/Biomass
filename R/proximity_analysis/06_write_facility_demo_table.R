

write_table <- function(facility_demo_table, table_name) {
  
output_path <- file.path('output', 'facility_data', paste0(table_name, '.xlsx'))
write.xlsx(facility_demo_table, output_path)

}
