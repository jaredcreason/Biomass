
# save_html.R

export_leaflet_map <- function(leaflet_output, map_title, output_dir = 'output') {
  
  filepath <- file.path(output_dir, paste0(map_title, '.html'))
  
  saveWidget(leaflet_output, file = filepath)
  
  cat("Leaflet map exported successfully as", filepath)
  
  
}
