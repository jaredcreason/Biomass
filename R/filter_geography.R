
# filter_geography.R


filter_acs_by_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State %in% state_list, ]
  return(filtered_data)
}




filter_facilities_by_state <- function(dataset, state_list) {
  
  filtered_data <- dataset[dataset$State_Prov %in% state_list, ]
  return(filtered_data)
}