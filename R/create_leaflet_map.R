
# create_leaflet_map.R

create_leaflet_map <- function(filtered_acs_health, filtered_facilities) {
  
  
  binpal <- colorBin('YlOrRd', filtered_acs_health$`Total Cancer Risk (per million)`)
  
  
  health_outcomes_leaflet <- leaflet() %>% 
    
    addTiles() %>%
    addPolygons(data = filtered_acs_health,
                color = ~binpal(`Total Cancer Risk (per million)`),
                weight = 1.0,
                fillOpacity = 0.5) %>%
    
    
    addMarkers(data = filtered_facilities,# %>% filter(Type == 'pulp/paper'),
               lat = ~Latitude,
               lng = ~Longitude) %>%
    
    addLegend('bottomright',
              pal = binpal,
              values = filtered_acs_health$`Total Cancer Risk (per million)`,
              title = 'Cancer Risk (per Million)',
              opacity = 1,
              labFormat = labelFormat(transform = function(x) sort(x))
    )
  
  return(health_outcomes_leaflet)
  
}
