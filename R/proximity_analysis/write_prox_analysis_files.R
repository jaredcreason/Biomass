

write_summary_means_table <- function(summary_table, final_table_name, output_dir = 'output/summary_tables') {
  
  
  filepath <- file.path(output_dir, paste0(final_table_name, '_summary_table.html'))
  
  summary_table %>% mutate(across(where(is.numeric), round,2)) %>% 
    kbl(caption = "Overall Community Profile and Health Outcomes for Communities Near Identified Facilities",
        format = "html",
        col.names = c("",
                      "Overall National Average",
                      "Rural Areas National Average",
                      "Within 1 mile of production facility",
                      "Within 3 miles of production facility",
                      "Within 5 miles of production facility",
                      "Within 10 miles of production facility"
        ),
        align = "r") %>%
    kable_styling(bootstrap_options = 'striped') %>% 
    kable_classic(full_width = F, html_font = "Cambria") %>% 
    save_kable(filepath)
}




