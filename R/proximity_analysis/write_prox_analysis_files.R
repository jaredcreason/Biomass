

write_summary_means_table <- function(final_summary_table,
                                      final_file_name,
                                      table_title,
                                      fac_sf_rural) {
  
  
  filepath <- file.path('output/summary_tables', paste0(final_file_name, '_summary_table.html'))
  
  length_facs <- length(fac_sf_rural$Label)
  
  rural <- fac_sf_rural %>% filter(rural==1)
  urban <- fac_sf_rural %>% filter(rural==0)

  
  
 table <-  final_summary_table %>%
    mutate(across(where(is.numeric), round, 2)) %>%
    kbl(
      caption = paste(
        "Overall Community Profile and Health Outcomes for Communities Near ",
        length_facs,
        table_title,
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
    kable_classic(full_width = F, html_font = "Cambria")
  
  save_kable(table,filepath)
}

write_summary_sd_table <- function(final_summary_table,
                                   final_file_name,
                                   table_title,
                                   fac_sf_rural) {
  
  
  length_facs <- length(fac_sf_rural$Label)
  
  rural <- fac_sf_rural %>% filter(rural==1)
  urban <- fac_sf_rural %>% filter(rural==0)
  filepath <- file.path('output/summary_tables/sd_tables/', paste0(final_file_name, '_summary_sd_table.html'))
  
  final_summary_table %>% mutate(across(where(is.numeric), round, 2)) %>%
    kbl(
      caption = paste(
        "Overall Community Profile and Health Outcomes for Communities Near ",
        length_facs,
        table_title,
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

write_summary_means_table_gt <- function(final_summary_table,
                                      final_file_name,
                                      table_title,
                                      fac_sf_rural) {
  
  
  filepath <- file.path('output/summary_tables', paste0(final_file_name, '_summary_table.png'))
  
  length_facs <- length(fac_sf_rural$Label)
  
  rural <- fac_sf_rural %>% filter(rural==1)
  urban <- fac_sf_rural %>% filter(rural==0)
  
  
  
  table <-  final_summary_table %>%
    mutate(across(where(is.numeric), round, 2)) %>%
    gt() %>%
    tab_header(
      title = paste(
        "Overall Community Profile and Health Outcomes for Communities Near",
        length_facs,
        table_title,
        " Facilities;",
        length(rural$Label),
        'Rural and',
        length(urban$Label),
        'Urban'
      )
    ) %>%
    cols_label(
      "Natl_Average" = "Overall National Average",
      "Natl_Rural_Average" = "Rural Areas National Average",
      "Facility_Buffer_Average_1mi" = "Within 1 mile of facilities",
      "Facility_Buffer_Average_3mi" = "Within 3 mile of facilities",
      "Facility_Buffer_Average_5mi" = "Within 5 mile of facilities",
      "Facility_Buffer_Average_10mi" = "Within 10 mile of facilities"
    ) %>%
    gt_theme_538()
  
  
  gtsave(table, filepath)
    
    
  
}

