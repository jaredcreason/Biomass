
load_ats_2020 <- function(ats_2020_folder_path) {
  
  filepaths <- dir_ls(ats_2020_folder_path)
  
  ats_2020_dfs <- list()
  
  for(filepath in filepaths) {
    
    df <- read_excel(filepath)
    
    df$Tract <- substr(df$Block, 1, 11)
    
    df_Tract <- df %>%
      group_by(Tract) %>%
      summarise(`Total Cancer Risk (per million)` = mean(`Total Cancer Risk (per million)`))
    
    rm(df)
    
    ats_2020_dfs[[filepath]] <- df_Tract
  
  }
  
  ats_2020_tract_df <- bind_rows(ats_2020_dfs)
  
  return(ats_2020_tract_df)
}

# 
# al_shp <- sf::read_sf("data/shapefiles/tl_2020_01_tract.shp") %>%
#   select(GEOID, geometry)
# 
# 
# df_al <- df %>%
#   filter(Tract %in% unique(al_shp$GEOID))
# 
# df_al_map <- df_Tract %>%
#   left_join(al_shp, by = c("Tract" = "GEOID"))
# 
# ggplot() +
#   geom_sf(data = df_al_map$geometry,
#           aes(fill = df_al_map$`Total Cancer Risk (per million)`))
