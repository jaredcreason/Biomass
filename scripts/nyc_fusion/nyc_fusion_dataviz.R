
source("packages.R")

# Create joined NYC/RECS dataframe
source('scripts/nyc_fusion/nyc_fusion_eda.R')


################################################################

# Add geometry column to joined dataset

nyc_tract_geometry <- load_data('data/nyc_fusion/ACS_JWMNP_NYC/') %>% select(TRACT, geometry) %>% rename(tract = TRACT)

nyc_joined_geometry <- nyc_joined %>% left_join(nyc_tract_geometry) %>% select(tract, geometry, everything())


###############

# init leaflet map

