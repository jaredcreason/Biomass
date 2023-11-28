
# R/data-collection.R


#' read_data_file
#'
#' @param filepath
#'
#' @return
#' @exportf
#' 


load_acs_data <- function(acs_filepath){
  loaded_data <- load(acs_filepath)
  return(data)
  
}


load_facilities_data <- function(facilities_filepath){
  read_excel("data/All_mills_ACS.xlsx",
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
