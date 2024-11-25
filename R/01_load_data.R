
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


load_all_mills <- function(all_mills_filepath){
  read_excel(all_mills_filepath,
             range = c("a6:ba1378")
  )%>%
    
    mutate(Label = `Mill_ID`) %>%
    select(Label,Longitude,Latitude,everything()) #%>%
   # filter(Status=='Open')
  
}

load_tri_facilities_data <- function(tri_facilities_filepath){
  
  tri_fac_data <- read_csv(tri_facilities_filepath) %>%
    mutate(Label = `2. TRIFD`) %>%
    
    select(Label, `2. TRIFD`, `3. FRS ID`, `4. FACILITY NAME`,`5. STREET ADDRESS`,`6. CITY`,`7. COUNTY`,`8. ST`,`9. ZIP`,`10. BIA`,`11. TRIBE`,
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
  
  return(tri_fac_data)
  
}

load_sch_h_facilities <- function(sch_h_filepath){
  
  facs <- read_excel(file.path(sch_h_filepath)) %>% mutate(Label = `REPORTED ADDRESS`) %>% drop_na(Label)
  
  return(facs)
}

load_subpart_w_facilities <- function(subpart_w_filepath){
  
  facs <- read_csv(subpart_w_filepath) %>%
    mutate(Label = `facility_id`)

  return(facs)
}


############

load_ats_cancer <- function(ats_cancer_filepath){
  read_excel(file.path(ats_cancer_filepath)) %>%
    rename(total_risk='Total Cancer Risk (per million)')
}


load_ats_resp <- function(ats_resp_filepath){
  read_excel(ats_resp_filepath) %>%
    rename(total_risk_resp='Total Respiratory (hazard quotient)') %>%
    select(Tract, total_risk_resp)
}

load_places_cancer <- function(places_data_filepath){
  places_data <- read.csv(places_data_filepath)
  cancer_data <- places_data %>% filter(MeasureId == 'CANCER') %>%
    mutate(cancer_prev = Data_Value) %>% 
    mutate(Tract = str_pad(LocationName, 11, pad='0', side = 'left')) %>%
    select(Tract, cancer_prev)
  
  
}


load_asthma <- function(places_data_filepath){
  places_data <- read.csv(places_data_filepath)
  asthma_data <- places_data %>% filter(MeasureId == 'CASTHMA') %>%
    mutate(asthma_prev = Data_Value) %>% 
    mutate(Tract = str_pad(LocationName, 11, pad='0', side = 'left')) %>%
    select(Tract, asthma_prev)
  
  
}



load_chd <- function(places_data_filepath){
  places_data <- read.csv(places_data_filepath)
  heart_data <- places_data %>% filter(MeasureId == 'CHD') %>%
    mutate(chd_prev = Data_Value) %>% 
    mutate(Tract = str_pad(LocationName, 11, pad='0', side = 'left')) %>%
    select(Tract, chd_prev)
  
}


load_health_ins <- function(places_data_filepath){
  places_data <- read.csv(places_data_filepath)
  asthma_data <- places_data %>% filter(MeasureId == 'ACCESS2') %>%
    mutate(health_ins = Data_Value) %>% 
    mutate(Tract = str_pad(LocationName, 11, pad='0', side = 'left')) %>%
    select(Tract, health_ins)
  
  
}
