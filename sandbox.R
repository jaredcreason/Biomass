
# sandbox.R

source('packages.R')
source('R/01_load_data.R')

acs_data <- load_acs_data('data/acs_data/acs_data_2021_block group.Rdata')


ats_cancer <- load_ats_cancer('data/ats_data/2019_National_CancerRisk_by_tract_poll.xlsx')
ats_resp <- load_ats_resp('data/ats_data/2019_National_RespHI_by_tract_poll.xlsx')

nata_data <- left_join(ats_cancer, ats_resp, by = 'Tract')

rm(ats_cancer)
rm(ats_resp)


# rearrange tibble column

nata_data <- nata_data %>% 
  select(
    1:7,
    ncol(nata_data),
    everything()
  )

##########################################
##########################################

data_ct <-acs_data %>% 
  mutate(Tract=substr(GEOID,1,11))

shp = data_ct %>%
  filter(variable=="pop") %>%
  select(GEOID,Tract) %>%
  arrange(GEOID) %>%
  st_transform(3488)


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

acs_health_data <- acs_health_data %>% left_join(nata_data,by=c("Tract"="Tract"))






##############################################
##############################################

filter_acs_by_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State %in% state_list, ]
  return(filtered_data)
}


geography_list <- c('GA')

mill_type_list <- c('pulp/paper')

acs_health_ga <- filter_acs_by_state(acs_health_data, geography_list)

write.csv(acs_health_ga, 'acs_health_ga.csv')
rm(acs_health_data)


###########################################
##########################################

state_list <- c('GA')

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








########################################
#######################################


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
  
  
  addMarkers(data = tri_facilities_GA,
             lat = ~`12. LATITUDE`,
             lng = ~`13. LONGITUDE`,
           popup = paste("TRI FACILITY", 
                         
                         "<br>",
                         
                         "Name: ", tri_facilities_GA$`4. FACILITY NAME`, "<br>",
                           "Industry Sector: ", tri_facilities_GA$`20. INDUSTRY SECTOR`, "<br>",
                           "Chemical: ", tri_facilities_GA$`34. CHEMICAL`, "<br>",
                           "Carcinogen: ", tri_facilities_GA$`43. CARCINOGEN`, "<br>",
                           
                           '<br>',
                          
                           
                           "City: ", tri_facilities_GA$`6. CITY`, "<br>",
                           "County: ", tri_facilities_GA$`7. COUNTY`, "<br>",
                           "State: ", tri_facilities_GA$`8. ST`, "<br>"
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





##################################################
## Add TRI mapping 

tri_facilities <- read_csv("data/tri_data/tri_2020_us.csv") %>%
  
  select(`3. FRS ID`, `4. FACILITY NAME`,`5. STREET ADDRESS`,`6. CITY`,`7. COUNTY`,`8. ST`,`9. ZIP`,`10. BIA`,`11. TRIBE`,
         `12. LATITUDE`,`13. LONGITUDE`,`14. HORIZONTAL DATUM`,
         `15. PARENT CO NAME`,
         `27. PRIMARY NAICS`,`20. INDUSTRY SECTOR`,
         `34. CHEMICAL`,`43. CARCINOGEN`,`46. UNIT OF MEASURE`,
         `47. 5.1 - FUGITIVE AIR`,`48. 5.2 - STACK AIR`,`49. 5.3 - WATER`,
         `51. 5.4.1 - UNDERGROUND CL I`,`52. 5.4.2 - UNDERGROUND C II-V`,
         `54. 5.5.1A - RCRA C LANDFILL`,`55. 5.5.1B - OTHER LANDFILLS`,`56. 5.5.2 - LAND TREATMENT`,
         `58. 5.5.3A - RCRA SURFACE IM`,`59. 5.5.3B - OTHER SURFACE I`,`60. 5.5.4 - OTHER DISPOSAL`,
         `61. ON-SITE RELEASE TOTAL`,
         `62. 6.1 - POTW - TRNS RLSE`,`63. 6.1 - POTW - TRNS TRT`,`64. POTW - TOTAL TRANSFERS`,
         `84. OFF-SITE RELEASE TOTAL`,`90. OFF-SITE RECYCLED TOTAL`,`93. OFF-SITE ENERGY RECOVERY T`,
         `100. OFF-SITE TREATED TOTAL`,`101. 6.2 - UNCLASSIFIED`,`102. 6.2 - TOTAL TRANSFER`,
         `103. TOTAL RELEASES`)


state_list_test <- c('GA')
industry_list_test <- c('Wood Products')

tri_facilities_GA <- tri_facilities %>%
  filter(`8. ST` %in% state_list_test) %>% 
  filter(`20. INDUSTRY SECTOR` %in% industry_list_test)

rm(tri_facilities)




##############################################
########### TRI Proximity Analysis
#############################################

tri_facilities_ga <- read_csv('tri_facilities_ga.csv')


acs_health_ga <- read.xlsx('acs_health_ga.xlsx')

urban_areas <- urban_areas()



#####################################################




facilities <- tri_facilities_ga %>% mutate(Label = `4. FACILITY NAME`)



facilities_lat_lon <- facilities %>% 
  select(`13. LONGITUDE`,`12. LATITUDE`,Label) %>%
  rename(lon =`13. LONGITUDE`,
         lat = `12. LATITUDE`)



facilities_sf = st_as_sf(facilities, 
                         coords=c(x="13. LONGITUDE",y="12. LATITUDE"), 
                         crs=4326) %>%
  st_transform(3488) 

### Indicating rural vs urban facilities. 1 = rural, 0 = urban

uac <- urban_areas %>% st_transform(3488)

facilities_sf_urban <- st_intersection(facilities_sf,uac) %>%
  mutate(rural = 0)

facilities_sf_rural <- facilities_sf %>%
  mutate(rural = fifelse(`4. FACILITY NAME` %in% unique(facilities_sf_urban$`4. FACILITY NAME`),0,1)) %>%
  as.data.frame() %>%
  select(rural,`4. FACILITY NAME`)

facilities_map <- left_join(facilities_sf, facilities_sf_rural, by = 'Label')

facilities_map <- facilities_sf %>%
  left_join(facilities_sf_rural, by = "Label") %>%
  left_join(facilities_lat_lon, by = "Label")



left_join()

#####################################





urban_tracts <- readRDS("data/urban_tracts.rds")



shp_rural <- shp %>% mutate(rural = fifelse(Tract %in% urban_tracts$Tract,0,1))

# identify rural and urban census blocks
sq_miles <- shp %>% mutate(sq_miles = units::set_units(st_area(shp),"mi^2")) %>%
  select(GEOID,sq_miles)

units(sq_miles$sq_miles) <- NULL

# prepare for merge with data
sq_miles %<>% st_set_geometry(NULL) %>% as.data.table() %>% setkey('GEOID')

# draw a buffer around the facilities
# buffer_dist is in miles so we need to multiply by 1609.34 meters/mile

communities = st_buffer(facilities_map, dist=1*1609.34) 

communities_3mi = st_buffer(facilities_map, dist=3*1609.34)

communities_5mi = st_buffer(facilities_map, dist=5*1609.34)

communities_10mi = st_buffer(facilities_map, dist=10*1609.34)

# find the census geographies within the buffer around the facilities

buffer = st_intersection(communities,shp) %>%
  select(GEOID,Tract,Label)

buffer_3mi = st_intersection(communities_3mi,shp) %>%
  select(GEOID,Tract,Label)

buffer_5mi = st_intersection(communities_5mi,shp) %>%
  select(GEOID,Tract,Label)

buffer_10mi = st_intersection(communities_10mi,shp) %>%
  select(GEOID,Tract,Label)

# # get GEOID to facility list
facility_buffer <- st_intersection(facilities_map, buffer) %>% select(Label, GEOID) %>% st_set_geometry(NULL)

facility_buffer_3mi <- st_intersection(facilities_map, buffer_3mi) %>% select(Label, GEOID) %>% st_set_geometry(NULL)

facility_buffer_5mi <- st_intersection(facilities_map, buffer_5mi) %>% select(Label, GEOID) %>% st_set_geometry(NULL)

facility_buffer_10mi <- st_intersection(facilities_map, buffer_10mi) %>% select(Label, GEOID) %>% st_set_geometry(NULL)

# drop the geometry to work with the data alone
table_full <- data_ct %>% 
  st_set_geometry(NULL) %>%
  as.data.table() %>% 
  setkey('GEOID')

table_1 <- table_full[sq_miles]

# merge the acs and nata data

nata_data <- read.xlsx('data/nata_data/national_cancerrisk_by_tract_poll.xlsx')
nata_data_resp <- read.xlsx('data/nata_data/national_resphi_by_tract_poll.xlsx')


table_2 <- table_1 %>%
  pivot_wider(names_from=variable,values_from=estimate) %>%
  mutate(white_pct=(white/pop)*100,
         minority_black=(black/pop)*100,
         minority_other=((pop-(white + black))/pop)*100,
         minority_hispanic=(hispanic/hispanic_denominator)*100,
         pov99=pov99/pop*100,
         pov50=pov50/pop*100,
         income=income/1000,
         rural = fifelse(Tract %in% urban_tracts$Tract,0,1)) %>%
  left_join(nata_data,by=c("Tract"="Tract")) %>%
  left_join(nata_data_resp,by=c("Tract"="Tract")) %>%
  as.data.table() %>%
  setkey('GEOID')

table_2$total_risk_resp <- table_2$`Total Respiratory (hazard quotient)`

table_2 <- acs_health_ga

# merge the acs and facility data

facility_demographics_1mi_pre <- merge(as.data.table(facilities_map), as.data.table(buffer),by="Label", allow.cartesian = TRUE)
facility_demographics_3mi_pre <- merge(as.data.table(facilities_map), as.data.table(buffer_3mi),by="Label")
facility_demographics_5mi_pre <- merge(as.data.table(facilities_map), as.data.table(buffer_5mi),by="Label")
facility_demographics_10mi_pre <- merge(as.data.table(facilities_map), as.data.table(buffer_10mi),by="Label")

facility_demographics_1mi_mid <- merge(facility_demographics_1mi_pre, table_2, by="GEOID") %>% 
  select(Label,City,Total_Wood,GEOID,sq_miles,rural.x,rural.y,pop,
         white,black,indian,asian,hispanic,income,pov50,pov99,
         total_risk,total_risk_resp) %>%
  rename(rural_facility = rural.x, rural_blockgroup = rural.y)

facility_demographics_3mi_mid <- merge(facility_demographics_3mi_pre, table_2, by="GEOID") %>% 
  select(Label,City,Total_Wood,GEOID,sq_miles,rural.x,rural.y,pop,
         white,black,indian,asian,hispanic,income,pov50,pov99,
         total_risk,total_risk_resp) %>%
  rename(rural_facility = rural.x, rural_blockgroup = rural.y)

facility_demographics_5mi_mid <- merge(facility_demographics_5mi_pre, table_2, by="GEOID") %>% 
  select(Label,City,Total_Wood,GEOID,sq_miles,rural.x,rural.y,pop,
         white,black,indian,asian,hispanic,income,pov50,pov99,
         total_risk, total_risk_resp) %>%
  rename(rural_facility = rural.x, rural_blockgroup = rural.y)

facility_demographics_10mi_mid <- merge(facility_demographics_10mi_pre, table_2, by="GEOID") %>% 
  select(Label,City,Total_Wood,GEOID,sq_miles,rural.x,rural.y,pop,
         white,black,indian,asian,hispanic,income,pov50,pov99,
         total_risk,total_risk_resp) %>%
  rename(rural_facility = rural.x, rural_blockgroup = rural.y)

facility_demographics_1mi <- facility_demographics_1mi_mid %>%
  group_by(Label,City,Total_Wood) %>%
  mutate(
    blockgroups_n = n(), 
    sq_miles = sum(sq_miles, na.rm=TRUE), 
    pop = sum(pop, na.rm=TRUE),
    white = sum(white, na.rm=TRUE),
    black = sum(black, na.rm=TRUE),
    indian = sum(indian, na.rm=TRUE),
    asian = sum(asian, na.rm=TRUE),
    hispanic = sum(hispanic, na.rm=TRUE),
    income = mean(income, na.rm=TRUE),
    pov50 = mean(pov50, na.rm=TRUE), 
    pov99 = mean(pov99, na.rm=TRUE), 
    total_risk = mean(total_risk, na.rm=TRUE), 
    total_risk_resp = mean(total_risk_resp, na.rm=TRUE)) %>%
  mutate(pop_sq_mile_1mi = pop/sq_miles,
         rural_bg_pct = signif(sum(rural_blockgroup/blockgroups_n, na.rm=TRUE),2)) %>% 
  ungroup() %>%
  select(Label,City,Total_Wood,blockgroups_n,sq_miles,pop,pop_sq_mile_1mi,
         rural_facility,rural_bg_pct,white,black,indian,asian,hispanic,
         income,pov50,pov99,total_risk,total_risk_resp) %>% 
  distinct()

write.xlsx(facility_demographics_1mi,"output/facility_data/allocation_rule_facility_demographics_1mi.xlsx", overwrite = TRUE)

facility_demographics_3mi <- facility_demographics_3mi_mid %>%
  group_by(Label,City,Total_Wood) %>%
  mutate(blockgroups_n = n(), 
         sq_miles = sum(sq_miles, na.rm=TRUE), 
         pop = sum(pop, na.rm=TRUE),
         white = sum(white, na.rm=TRUE),
         black = sum(black, na.rm=TRUE),
         indian = sum(indian, na.rm=TRUE),
         asian = sum(asian, na.rm=TRUE),
         hispanic = sum(hispanic, na.rm=TRUE),
         income = mean(income, na.rm=TRUE),
         pov50 = mean(pov50, na.rm=TRUE), 
         pov99 = mean(pov99, na.rm=TRUE), 
         total_risk = mean(total_risk, na.rm=TRUE), 
         total_risk_resp = mean(total_risk_resp, na.rm=TRUE)) %>%
  mutate(pop_sq_mile_3mi = pop/sq_miles,
         rural_bg_pct = signif(sum(rural_blockgroup/blockgroups_n, na.rm=TRUE),2)) %>% 
  ungroup() %>%
  select(Label,City,Total_Wood,blockgroups_n,sq_miles,pop,pop_sq_mile_3mi,
         rural_facility,rural_bg_pct,white,black,indian,asian,hispanic,
         income,pov50,pov99,total_risk,total_risk_resp) %>% 
  distinct()

write.xlsx(facility_demographics_3mi,"output/facility_data/allocation_rule_facility_demographics_3mi.xlsx", overwrite = TRUE)

facility_demographics_5mi <- facility_demographics_5mi_mid %>%
  group_by(Label,City,Total_Wood) %>%
  mutate(blockgroups_n = n(), 
         sq_miles = sum(sq_miles, na.rm=TRUE), 
         pop = sum(pop, na.rm=TRUE),
         white = sum(white, na.rm=TRUE),
         black = sum(black, na.rm=TRUE),
         indian = sum(indian, na.rm=TRUE),
         asian = sum(asian, na.rm=TRUE),
         hispanic = sum(hispanic, na.rm=TRUE),
         income = mean(income, na.rm=TRUE),
         pov50 = mean(pov50, na.rm=TRUE), 
         pov99 = mean(pov99, na.rm=TRUE), 
         total_risk = mean(total_risk, na.rm=TRUE), 
         total_risk_resp = mean(total_risk_resp, na.rm=TRUE)) %>%
  mutate(pop_sq_mile_5mi = pop/sq_miles,
         rural_bg_pct = signif(sum(rural_blockgroup/blockgroups_n, na.rm=TRUE),2)) %>% 
  ungroup() %>%
  select(Label,City,Total_Wood,blockgroups_n,sq_miles,pop,pop_sq_mile_5mi,
         rural_facility,rural_bg_pct,white,black,indian,asian,hispanic,
         income,pov50,pov99,total_risk,total_risk_resp) %>% 
  distinct()

write.xlsx(facility_demographics_5mi, file = "output/facility_data/allocation_rule_facility_demographics_5mi.xlsx", overwrite = TRUE)

facility_demographics_10mi <- facility_demographics_10mi_mid %>%
  group_by(Label,City,Total_Wood) %>%
  mutate(blockgroups_n = n(), 
         sq_miles = sum(sq_miles, na.rm=TRUE), 
         pop = sum(pop, na.rm=TRUE),
         white = sum(white, na.rm=TRUE),
         black = sum(black, na.rm=TRUE),
         indian = sum(indian, na.rm=TRUE),
         asian = sum(asian, na.rm=TRUE),
         hispanic = sum(hispanic, na.rm=TRUE),
         income = mean(income, na.rm=TRUE),
         pov50 = mean(pov50, na.rm=TRUE), 
         pov99 = mean(pov99, na.rm=TRUE), 
         total_risk = mean(total_risk, na.rm=TRUE), 
         total_risk_resp = mean(total_risk_resp, na.rm=TRUE)) %>%
  mutate(pop_sq_mile_10mi = pop/sq_miles,
         rural_bg_pct = signif(sum(rural_blockgroup/blockgroups_n, na.rm=TRUE),2)) %>% 
  ungroup() %>%
  select(Label,City,Total_Wood,blockgroups_n,sq_miles,pop,pop_sq_mile_10mi,
         rural_facility,rural_bg_pct,white,black,indian,asian,hispanic,
         income,pov50,pov99,total_risk,total_risk_resp) %>% 
  distinct()

write.xlsx(facility_demographics_10mi,"output/facility_data/allocation_rule_facility_demographics_10mi.xlsx", overwrite = TRUE)

###\


ID_column_name = 'Mill_Name'

longitude_col_name = 'Longitude'

latitude_col_name = 'Latitude'



fac_map_test <- prep_facilities(facilities_ga_paper,
                                ID_column_name,
                                longitude_col_name,
                                latitude_col_name)

###############################################################
comparison_vars <- c("white_pct",'minority_black','minority_other','minority_hispanic',
                     "income",
                     "pov99","pov50",
                     "total_risk","total_risk_resp")


# descriptions of the comparison variables to be included in the tables
desc_vars <- c("% White","% Black or African American ","% Other","% Hispanic",
               "Median Income [1,000 2019$]",
               "% Below Poverty Line","% Below Half the Poverty Line",
               "Total Cancer Risk (per million)",
               'Total Respiratory (hazard quotient)')


tar_load(acs_health_table)

tar_load(gen_bufferzone)

buffer_radius_mi <- 5

final_table_name = 'GA_TRI_wood_products_5mi'



#########################################################


  summary_table = data.frame(Variable=desc_vars)

summary_table$Population_Average <- sapply(comparison_vars, function(var) {
  
  weighted.mean(acs_health_table[[var]], acs_health_table$pop, na.rm = TRUE)
})



rural <- acs_health_table %>% filter(rural == 1)

summary_table$Rural_Average <- sapply(comparison_vars, function(var) {
  
  weighted.mean(rural[[var]], rural$pop, na.rm = TRUE)
})

urban <- acs_health_table %>% filter(rural == 0)

summary_table$Urban_Average <- sapply(comparison_vars, function(var) {
  
  weighted.mean(urban[[var]], urban$pop, na.rm = TRUE)
})


local_geoids <- gen_bufferzone$GEOID

local_cts = acs_health_table %>% filter(GEOID %in% local_geoids)


summary_table$`Within Buffer Radius` <- sapply(comparison_vars, function(var) {
  
  weighted.mean(rural[[var]], rural$pop, na.rm = TRUE)
})

  
  # get the national level averages
  
  for (var in comparison_vars) {
    summary_table[v,"Overall (Population Average)"] = sum(acs_health_table$pop*acs_health_table$vars)/sum(acs_health_table$pop,na.rm=T)
    
  }
  
  # get the rural area level averages
  rural <- acs_health_table %>% filter(rural==1)
  for (v in 1:length(comparison_vars)) {
    summary_table[v,"Rural Areas (Population Average)"] = sum(rural$pop*rural[,comparison_vars[v]],na.rm=T)/sum(rural$pop,na.rm=T)
  }
  
  # get the urban area level averages
  urban <- acs_health_table %>% filter(rural==0)
  for (v in 1:length(comparison_vars)) {
    summary_table[v,"Urban Areas (Population Average)"] = sum(rural$pop*rural[,comparison_vars[v]],na.rm=T)/sum(rural$pop,na.rm=T)
  }
 


################################
##################################




  summary_table_sd = data.frame(Variable=desc_vars)
  
  summary_table_sd$Population_SD <- sapply(comparison_vars, function(var) {
    sd(acs_health_table[[var]], na.rm = TRUE)
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  ##############################################
  
  for (v in 1:length(comparison_vars)) {
    a = (acs_health_table$pop*acs_health_table[,comparison_vars[v]])/acs_health_table$pop
    summary_table_sd[v,"Overall (Population Average) SD"] = sqrt(sum((a-mean(a, na.rm=TRUE))^2/(length(a)-1), na.rm=TRUE))
  }
  
  # get the rural area level std devs
  rural <- acs_health_table %>% filter(rural==1)
  for (v in 1:length(comparison_vars)) {
    a = (rural$pop*rural[,comparison_vars[v]])/rural$pop
    summary_table_sd[v,"Rural Areas (Population Average) SD"] = sqrt(sum((a-mean(a, na.rm=TRUE))^2/(length(a)-1), na.rm=TRUE))
  }
  
  # get the population weighted SD around the production facilities
  local = acs_health_table$GEOID %in% unique(buffer$GEOID)
  for (v in 1:length(comparison_vars)) {
    a = (acs_health_table$pop[local]*acs_health_table[local,comparison_vars[v]])/acs_health_table$pop[local]
    summary_table_sd[v,paste("Within ",buffer_radius_mi," mile(s) of production facility SD")] = sqrt(sum((a-mean(a, na.rm=TRUE))^2/(length(a)-1), na.rm=TRUE))
  }
  
  #################################
  ###################################
  

    output_path <- file.path('output', 'summary_tables', paste0(final_table_name,'_means','.xlsx'))
    write.xlsx(summary_table, output_path)  
  
  
  

    output_path <- file.path('output', 'summary_tables', paste0(final_table_name,'_standard_deviations','.xlsx'))
    write.xlsx(summary_table_sd, output_path)  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
