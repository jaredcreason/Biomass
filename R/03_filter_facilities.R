
# filter_geography.R


filter_acs_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State %in% state_list, ]
  return(filtered_data)
}

###########################


filter_facilities_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State_Prov %in% state_list, ]
  
  return(filtered_data)
}



filter_facilities_type <- function(dataset, type_list) {
  
  filtered_data <- dataset[dataset$Type %in% type_list, ]
  return(filtered_data)
}

###########################

filter_tri_state <- function(dataset, state_list) {
  
  filtered_data <- dataset %>%
    filter(`8. ST` %in% state_list)
  
  return(filtered_data)
}


filter_tri_industry <- function(dataset, industry_list) {
  
  filtered_data <- dataset %>%
    filter(`20. INDUSTRY SECTOR` %in% industry_list)
  
  return(filtered_data)
}




filter_tri_facilities_states_industry <- function(dataset, state_list, industry_list) {
  
  filtered_data <- dataset %>%
    filter(`8. ST` %in% state_list) %>% 
    filter(`20. INDUSTRY SECTOR` %in% industry_list)
  
  return(filtered_data)
}


