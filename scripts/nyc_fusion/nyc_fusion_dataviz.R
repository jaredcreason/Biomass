
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

df_sf <- st_sf(nyc_joined_geometry, sf_column_name = 'geometry')
 
leaflet() %>% 
  addTiles() %>% 
  addPolygons()

ggplot() +
  geom_sf(data = nyc_joined_geometry$geometry, aes(fill = nyc_joined_geometry$borough)) +
  scale_fill_manual(values = c('Bronx' = 'blue',
                               'Brooklyn' = 'purple',
                               'Manhattan' = 'darkgreen',
                               'Queens' = 'yellow',
                               'Staten Island' = 'darkred'))
