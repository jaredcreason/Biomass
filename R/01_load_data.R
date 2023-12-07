
# R/data-collection.R


#' Read files into targets environment
#'
#' @param filepath file paths on local machine to ACS, Facilities, and NATA datasets.
#'
#' @return
#' @exportf
#' 


load_acs_data <- function(acs_filepath){
  loaded_data <- get(load(acs_filepath))
  return(loaded_data)
  
}


load_facilities_data <- function(facilities_filepath){
  read_excel(facilities_filepath,
             range = c("a6:ba1378")
  )%>%
    
    mutate(Label = `Mill_ID`) %>%
    select(Longitude,Latitude,everything())
  
}

load_ats_cancer <- function(ats_cancer_filepath){
  read_excel(file.path(ats_cancer_filepath)) %>%
    rename(total_risk='Total Cancer Risk (per million)')
}


load_ats_resp <- function(ats_resp_filepath){
  read_excel(ats_resp_filepath) %>%
    rename(total_risk_resp='Total Respiratory (hazard quotient)') %>%
    select(Tract, total_risk_resp)
}
