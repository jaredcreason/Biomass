
# sandbox.R

source('packages.R')
source('R/load_data.R')

load('data/acs_data/acs_data_2021_block group.Rdata')

cancer_data <- read_excel('data/ats_data/2019_National_CancerRisk_by_tract_poll.xlsx')
resp_data <- read_excel('data/ats_data/2019_National_RespHI_by_tract_poll.xlsx')

##########################################
##########################################

data_ct <-data %>% 
  mutate(Tract=substr(GEOID,1,11))
remove(data)


acs_health_data <- data_ct %>%
  pivot_wider(names_from='variable',values_from='estimate') %>%
  mutate(white_pct=(white/pop)*100,
         minority_black=(black/pop)*100,
         minority_other=((pop-(white + black))/pop)*100,
         minority_hispanic=(hispanic/hispanic_denominator)*100,
         pov99=pov99/pop*100,
         pov50=pov50/pop*100,
         income=income/1000)

rm(data_ct)

acs_health_data <- acs_health_data %>% left_join(cancer_data,by=c("Tract"="Tract"))






##############################################
##############################################

filter_acs_by_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State %in% state_list, ]
  return(filtered_data)
}


geography_list <- c('GA', 'FL')

acs_health_ga <- filter_by_states(acs_health_data, geography_list)


#rm(acs_health_data)


###########################################
##########################################


facilities_data <- load_facilities_data('data/All_Mills_ACS.xlsx')

filter_facilities_by_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State_Prov %in% state_list, ]
  return(filtered_data)
}

facilities_ga <- filter_facilities_by_state(facilities_data, geography_list)

###########################################
###########################################


binpal <- colorBin('YlOrRd', acs_health_ga$`Total Cancer Risk (per million)`)


facilities_map_ga <- leaflet() %>% 
  
  addTiles() %>%
  addPolygons(data = acs_health_ga,
              color = ~binpal(`Total Cancer Risk (per million)`),
              weight = 1.0,
              fillOpacity = 0.5) %>%
  
  
  addMarkers(data = facilities_ga,# %>% filter(Type == 'pulp/paper'),
             lat = ~Latitude,
             lng = ~Longitude) %>%
  
  addLegend('bottomright',
            pal = binpal,
            values = acs_health_ga$`Total Cancer Risk (per million)`,
            title = 'Cancer Risk (per Million)',
            opacity = 1,
            labFormat = labelFormat(transform = function(x) sort(x))
            )
  
facilties_map_GA_FL <- create_leaflet_map(acs_health_ga, facilities_ga)


##############################################
##############################################


