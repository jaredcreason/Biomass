

write_fac_dem_table <- function(facility_demo_table, table_name) {
  
output_path <- file.path('output', 'facility_data', paste0(table_name, '_fac_dem.xlsx'))
write.xlsx(facility_demo_table, output_path)

}
