
source("packages.R")

# Create joined NYC/RECS dataframe
source('scripts/nyc_fusion/nyc_fusion_eda.R')


################################################################

# Add geometry column to joined dataset

nyc_tract_geometry <- load_data('data/nyc_fusion/ACS_JWMNP_NYC/') %>% select(TRACT, geometry) %>% rename(tract = TRACT)

nyc_joined <- nyc_joined %>%
  rename(burden_recs = burden.x,
         burden_nhts = burden.y)

nyc_joined_geometry <-
  nyc_joined %>% left_join(nyc_tract_geometry) %>%
  
  mutate(
    borough = case_when(
      substring(tract, 4, 5) %in% c('05') ~ "Bronx",
      substring(tract, 4, 5) %in% c('47') ~ "Brooklyn",
      substring(tract, 4, 5) %in% c('61') ~ "Manhattan",
      substring(tract, 4, 5) %in% c('81') ~ "Queens",
      substring(tract, 4, 5) %in% c('85') ~ "Staten Island",
      TRUE ~ NA_character_
    )
  ) %>%
  select(tract, borough, geometry, everything()) 


###############



########################


borough_colors <- scale_fill_manual(values = c('Bronx' = 'blue',
                             'Brooklyn' = 'purple',
                             'Manhattan' = 'darkgreen',
                             'Queens' = 'yellow',
                             'Staten Island' = 'darkred'))
                             
        
variable <- nyc_joined_geometry$burden_recs

low_color <- 'yellow'
high_color <- 'red'
background_color <- '#191919'
text_color <- 'white'

ggplot() +
  geom_sf(data = nyc_joined_geometry$geometry, aes(fill = variable,
                                                   color = variable)) +
  scale_fill_gradient(low = low_color, high = high_color, name = title) +
  scale_color_gradient(low = low_color, high = high_color, name = title) +
  theme_void() +
  theme(plot.background = element_rect(fill = background_color),
        legend.text = element_text(color = text_color),
        legend.title = element_text(color = text_color)) +
  labs(fill = title, color = title)


variables_list <- names(nyc_joined)
output_dir <- 'output/nyc_fusion/nyc_maps/'

var <- variables_list[4]

for(var in variables_list[3:33]){
  title <- var

  
  ggplot() +
    geom_sf(data = nyc_joined_geometry$geometry, aes(fill = paste0(nyc_joined,$,var),
                                                     color = paste0(nyc_joined,$,var))) +
    scale_fill_gradient(low = low_color, high = high_color, name = title) +
    scale_color_gradient(low = low_color, high = high_color, name = title) +
    theme_void() +
    theme(plot.background = element_rect(fill = background_color),
          legend.text = element_text(color = text_color),
          legend.title = element_text(color = text_color)) +
    labs(fill = title, color = title)
  
  ggsave(paste0(output_dir,'nyc_downscaled_',var,'.jpg'))
}






