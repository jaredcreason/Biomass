

write_summary_means_table <- function(summary_table,
                                      final_table_name,
                                      facility_label,
                                      fac_sf_rural,
                                      output_dir = 'output/summary_tables') {
  
  
  filepath <- file.path(output_dir, paste0(final_table_name, '_summary_table.html'))
  
  length_facs <- length(fac_sf_rural$Label)
  
  rural <- fac_sf_rural %>% filter(rural==1)
  urban <- fac_sf_rural %>% filter(rural==0)

  
  
  summary_table %>% mutate(across(where(is.numeric), round, 2)) %>%
    kbl(
      caption = paste(
        "Overall Community Profile and Health Outcomes for Communities Near ",
        length_facs,
        facility_label,
        " Facilities;",
        length(rural$Label),
        'Rural and',
        length(urban$Label),
        'Urban'
      ),
      format = "html",
      col.names = c(
        "",
        "Overall National Average",
        "Rural Areas National Average",
        "Within 1 mile of facilities",
        "Within 3 miles of facilities",
        "Within 5 miles of facilities",
        "Within 10 miles of facilities"
      ),
      align = "r"
    ) %>%
    kable_styling(bootstrap_options = 'striped') %>%
    kable_classic(full_width = F, html_font = "Cambria") %>%
    save_kable(filepath)
}

write_summary_sd_table <- function(summary_table,
                                      final_table_name,
                                      facility_label,
                                   fac_sf_rural,
                                      output_dir = 'output/summary_tables/sd_tables/') {
  
  
  length_facs <- length(fac_sf_rural$Label)
  
  rural <- fac_sf_rural %>% filter(rural==1)
  urban <- fac_sf_rural %>% filter(rural==0)
  filepath <- file.path(output_dir, paste0(final_table_name, '_summary_sd_table.html'))
  
  summary_table %>% mutate(across(where(is.numeric), round, 2)) %>%
    kbl(
      caption = paste(
        "Overall Community Profile and Health Outcomes for Communities Near ",
        length_facs,
        facility_label,
        " Facilities;",
        length(rural$Label),
        'Rural and',
        length(urban$Label),
        'Urban'
      ),
      format = "html",
      col.names = c(
        "",
        "Overall National Standard Deviation",
        "Rural Areas National Standard Deviation",
        "Within 1 mile of facilities",
        "Within 3 miles of facilities",
        "Within 5 miles of facilities",
        "Within 10 miles of facilities"
      ),
      align = "r"
    ) %>%
    kable_styling(bootstrap_options = 'striped') %>%
    kable_classic(full_width = F, html_font = "Cambria") %>%
    save_kable(filepath)
}



