
# sandbox.R

source('packages.R')
source('R/01_load_data.R')

acs_data <- load_acs_data('data/acs_data/acs_data_2021_block group.Rdata')
rm(data)


cancer_data <- load_ats_cancer('data/ats_data/2019_National_CancerRisk_by_tract_poll.xlsx')
resp_data <- load_ats_resp('data/ats_data/2019_National_RespHI_by_tract_poll.xlsx')

##########################################
##########################################

data_ct <-acs_data %>% 
  mutate(Tract=substr(GEOID,1,11))

rm(acs_data)



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


geography_list <- c('GA')

mill_type_list <- c('pulp/paper')

acs_health_ga <- filter_acs_state(acs_health_data, geography_list)


rm(acs_health_data)


###########################################
##########################################


facilities_data <- load_facilities_data('data/All_Mills_ACS.xlsx')

filter_facilities_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State_Prov %in% state_list, ]
  return(filtered_data)
}


filter_facilities_type <- function(dataset, type_list) {
  
  filtered_data <- dataset[dataset$Type %in% type_list, ]
  return(filtered_data)
}


facilities_ga <- filter_facilities_state(facilities_data, geography_list)
facilities_ga_paper <- filter_facilities_type(facilities_ga, mill_type_list)


###########################################
###########################################


binpal <- colorBin('YlOrRd', acs_health_ga$total_risk, bins = 5)


facilities_map_ga <- leaflet() %>% 
  
  addTiles() %>%
  addPolygons(data = acs_health_ga,
              color = ~binpal(total_risk),
              weight = 1.0,
              fillOpacity = 0.5,
              popup = paste("Tract ID: ", acs_health_ga$Tract, "<br>",
                            "County: ", acs_health_ga$County, "<br>",
                            "State: ", acs_health_ga$State, "<br>",
                            "Population: ", comma(acs_health_ga$pop), "<br>",
                           
                             "<br>",
                            
                            "Cancer Risk: ", acs_health_ga$total_risk, "<br>",
                            "Percent White: ", round(acs_health_ga$white_pct,1),"%", "<br>",
                            "Median HH Income: ", "$", comma(acs_health_ga$income*1000), "<br>"
                            )) %>%
  
  
  addMarkers(data = facilities_ga_paper,
             lat = ~Latitude,
             lng = ~Longitude,
             popup = paste("Name: ", facilities_ga_paper$Mill_Name, "<br>",
                           "Mill Type: ", facilities_ga_paper$Type, "<br>",
                           "End Product: ", facilities_ga_paper$End_Use, "<br>",
                           "Status: ", facilities_ga_paper$Status, "<br>",
                           
                           '<br>',
                           
                           "Production Capacity: ", 
                           comma(facilities_ga_paper$Current_Ca),
                           facilities_ga_paper$Production, "<br>",
                           "Wood Input at Capacity: ",
                           comma(facilities_ga_paper$Total_Wood), 'Tons','<br>',
                           
                           '<br>',
                           
                           "City: ", facilities_ga_paper$City, "<br>",
                           "County: ", facilities_ga_paper$County, "<br>",
                           "State: ", facilities_ga_paper$State_Prov, "<br>"
             )) %>%
  
  addLegend('bottomright',
            pal = binpal,
            values = acs_health_ga$total_risk,
            title = 'Cancer Risk (per Million)',
            opacity = 1,
            labFormat = labelFormat(transform = function(x) sort(x))
            )
  
facilities_map_ga


##############################################
##############################################


facilities_pellet_data <- facilities_data %>% filter(Type == 'pellet')

facilities_lumber_data <- facilities_data %>% filter(Type == 'lumber') %>% filter(State_Prov == 'TX')

















