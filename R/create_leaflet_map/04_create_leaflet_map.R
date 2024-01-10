
# create_leaflet_map.R

create_leaflet_map <- function(filtered_acs_health,
                               filtered_facilities) {
  
  
  binpal <- colorBin('YlOrRd', filtered_acs_health$total_risk, bins = 5)
  
  
  cancer_risk_facility_map <- leaflet() %>% 
    
    addTiles() %>%
    addPolygons(data = filtered_acs_health,
                color = ~binpal(total_risk),
                weight = 1.0,
                fillOpacity = 0.5,
                popup = paste("Tract ID: ", filtered_acs_health$Tract, "<br>",
                              "County: ", filtered_acs_health$County, "<br>",
                              "State: ", filtered_acs_health$State, "<br>",
                              "Population: ", comma(filtered_acs_health$pop), "<br>",
                              
                              "<br>",
                              
                              "Cancer Risk: ", filtered_acs_health$total_risk, "<br>",
                              "Percent White: ", round(filtered_acs_health$white_pct,1),"%", "<br>",
                              "Median HH Income: ", "$", comma(filtered_acs_health$income*1000), "<br>"
                )) %>%
    
    
    addMarkers(data = filtered_facilities,
               lat = ~Latitude,
               lng = ~Longitude,
               popup = paste("Name: ", filtered_facilities$Mill_Name, "<br>",
                             "Mill Type: ", filtered_facilities$Type, "<br>",
                             "End Product: ", filtered_facilities$End_Use, "<br>",
                             "Status: ", filtered_facilities$Status, "<br>",
                             
                             '<br>',
                             
                             "Production Capacity: ", 
                             comma(filtered_facilities$Current_Ca),
                             filtered_facilities$Production, "<br>",
                             "Wood Input at Capacity: ",
                             comma(filtered_facilities$Total_Wood), 'Tons','<br>',
                             
                             '<br>',
                             
                             "City: ", filtered_facilities$City, "<br>",
                             "County: ", filtered_facilities$County, "<br>",
                             "State: ", filtered_facilities$State_Prov, "<br>"
               )) %>%
    
    
    addLegend('bottomright',
              pal = binpal,
              values = filtered_acs_health$total_risk,
              title = 'Cancer Risk (per Million)',
              opacity = 1,
              labFormat = labelFormat(transform = function(x) sort(x))
    )
  
  return(cancer_risk_facility_map)
  
}
