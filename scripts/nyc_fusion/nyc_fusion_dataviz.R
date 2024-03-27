
source("packages.R")

# Create joined NYC/RECS dataframe
source('scripts/nyc_fusion/nyc_fusion_eda.R')


################################################################

# Add geometry column to joined dataset

nyc_tract_geometry <- load_data('data/nyc_fusion/ACS_JWMNP_NYC/') %>% select(TRACT, geometry) %>% rename(tract = TRACT)


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

  # )
########################


borough_colors <- scale_fill_manual(values = c('Bronx' = 'blue',
                             'Brooklyn' = 'purple',
                             'Manhattan' = 'darkgreen',
                             'Queens' = 'yellow',
                             'Staten Island' = 'darkred'))
                             
        
variable <- nyc_joined_geometry$insec

low_color <- 'yellow'
high_color <- 'red'
background <- '#191919'

ggplot() +
  geom_sf(data = nyc_joined_geometry$geometry, aes(fill = variable,
                                                   color = variable)) +
  scale_fill_gradient(low = low_color, high = high_color) +
  scale_color_gradient(low = low_color, high = high_color) +
  theme_void() +
  theme(plot.background = element_rect(fill = background))
