

gen_acs_health_table <- function(data_ct, sq_miles, urban_tracts, nata_data, geography_col, state_list) {
  
  table_full <- data_ct %>% 
    st_set_geometry(NULL) %>%
    as.data.table() %>% 
    setkey('GEOID')
  
  rm(data_ct)
  

  table_1 <- table_full[sq_miles]
  
  rm(table_full)
  
  # merge the acs and nata data
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
    as.data.table() %>%
    setkey('GEOID') %>%
    filter(State == 'GA')
  
  rm(table_1)
  
  return(table_2)
}


merge_facility_buffer <- function(fac_map, buffer) {
  
  facility_demographics_pre <- merge(as.data.table(fac_map), as.data.table(buffer),by="Label", allow.cartesian = TRUE)
  
  return(facility_demographics_pre)
}


gen_fac_dem_mid <- function(fac_dem_pre, acs_health_table) {
  
  facility_demographics_mid <- merge(fac_dem_pre, acs_health_table, by="GEOID") %>% 
    select(Label,Mill_Name,City,Total_Wood,GEOID,sq_miles,rural.x,rural.y,pop,
           white,black,indian,asian,hispanic,income,pov50,pov99,
           total_risk,total_risk_resp) %>%
    rename(rural_facility = rural.x, rural_blockgroup = rural.y)
  
  return(facility_demographics_mid)
}


gen_fac_dem_table <- function(fac_dem_mid, sq_miles) {
  
  facility_demographics <- fac_dem_mid %>%
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
  
}


