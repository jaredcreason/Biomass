
# Biomass/_targets.R

######################################
### How to Run this Repository
######################################

# FIRST TIME ONLY: Script will query Census API ACS Data
# Runtime: (approx. 90 minutes)


# Step 1: Load required targets packages
library(targets)
library(tarchetypes)


# Step 2: Establish Area and Facilities of Interest 
#         by changing strings at beginning of tar_plan()

# Step 3: Run tar_make()

# Step 4: View rendered HTML map in /output directory.

###############################
######### Set-Up
################################

acs_data_filepath <- 'data/acs_data/acs_data_2021_block group.Rdata'

if (!file.exists(acs_data_filepath)) {
  source('scripts/acs_api_query.R')
} else {
  print('ACS Data already exists. Skipping Census API Query.')
}

source('packages.R')

tar_source()


tar_option_set(packages= c('tidyverse', 'leaflet','htmlwidgets'))


tar_plan(
 ############################################
 ##### Create Facility Interactive Map
  ##########################################
 
 
  
  ## Enter one or multiple U.S. State Abbreviations (max two recommended)
  states <- c('TX'),
  
 
 
  # Enter desired mill-type, options include:
 # "pellet", "plywood/veneer", "lumber", "pulp/paper", "chip", or "OSB" 
  
  mill_type <- c('pulp/paper'),
  
  
  # Enter desired file name of output .html file
  map_title <- 'TX_paper_facilities_map',

 

  
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
  
###########################################################################
 #############################################################################
 ###############################################################################
 
 # Planned Space for Proximity Analysis _targetification



)








