
# Biomass/_targets.R


source('packages.R')

library(targets)
library(tarchetypes)

tar_source()


tar_option_set(packages= c('tidyverse', 'leaflet','htmlwidgets'))


tar_plan(
  
  
  # Establish Regions of Interest
  
  # Enter one or multiple U.S. State Abbreviations
  states <- c('GA'),
  
  # Enter desired mill-type
  
  mill_type <- c('pulp/paper'),
  
  
  # Enter desired file name of output .html file
  map_title <- 'GA_paper_facility_map',

 ###########################
 ##### Load Packages
 ###########################
 
 #tar_target(
  # load_packages,
   #load_required_packages()
 #),
  
  
  
  
  
  ################################
  ###### Establish data file paths
  ################################
  
   
  #tar_target(acs_data,
   #          'data/acs_data/acs_data_2021_block group.Rdata',
    #         format = 'file'),
  
  
  tar_target(facilities_data,
             'data/All_mills_ACS.xlsx',
             format = 'file'),
  
  
  tar_target(ats_cancer_data,
             'data/ats_data/2019_National_CancerRisk_by_tract_poll.xlsx',
             format = 'file'),
  
  
  tar_target(ats_resp_data,
             'data/ats_data/2019_National_RespHI_by_tract_poll.xlsx',
             format = 'file'),
  
  
  
  #####################################
  ####### Load data using functions
  ######################################
  
  tar_target(acs_data_loaded,
             load_acs_data('data/acs_data/acs_data_2021_block group.Rdata')),
  
  tar_target(ats_cancer_loaded,
             load_ats_cancer(ats_cancer_data)),
  
  
  tar_target(ats_resp_loaded,
             load_ats_resp(ats_resp_data)),
  
  tar_target(facilities_data_loaded,
             load_facilities_data(facilities_data)),

  
  
 #########################################
 ####### Merge ACS and NATA Health Data
 ##########################################
  
  tar_target(merge_acs_health,
             merge_acs(acs_data_loaded, ats_cancer_loaded)),
  
 ###################################################
 ###### Subset region of interest from merged data
 ###################################################
 
  tar_target(filter_area,
             filter_acs_state(merge_acs_health, states)),
  

  tar_target(filter_facilities_by_state,
             filter_facilities_state(facilities_data_loaded, states)),
 
 
  tar_target(filter_facilities_final,
             filter_facilities_type(filter_facilities_by_state, mill_type)),
 
 
 
  
 ############################
 ##### Create Leaflet Map
 ###########################
 
  
  tar_target(create_leaflet,
             create_leaflet_map(filter_area, filter_facilities_final)),
  
 
 ############################
 #### Export Leaflet to HTML
 ############################ 
 
 
  tar_target(export_leaflet_as_html,
             export_leaflet_map(create_leaflet,
                                map_title = map_title),
             format = 'file')
  
  

  )










