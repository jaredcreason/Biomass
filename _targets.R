
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
######### Targets Set-Up
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
  states <- c('GA'),
  
 
 
  # Enter desired mill-type, options include:
 # "pellet", "plywood/veneer", "lumber", "pulp/paper", "chip", or "OSB" 
  
  mill_type <- c('pulp/paper'),
 
 tri_industry_sector <- c('Wood Products'),
  
  
  # Enter desired file name of output .html file
  map_title <- 'GA_paper_mills_map',

 
 ##############################################################
 
 # Proximity Analysis Set-Up
 
 buffer_radius_mi = 20,
 
 final_table_name = 'GA_paper_mills_20mi',
 
 ID_column_name = 'Mill_Name',
 
 geography_column_name = 'State',
 
 longitude_col_name = 'Longitude',
 
 latitude_col_name = 'Latitude',
 

  
  ################################
  ###### Establish data file paths
  ################################

  
  tar_target(facilities_data,
             'data/All_mills_ACS.xlsx',
             format = 'file'),
 
 
  tar_target(tri_facilities_data,
             'data/tri_data/tri_2020_us.csv',
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

  tar_target(tri_facilities_data_loaded,
             load_tri_facilities_data(tri_facilities_data)),

  
  
 #########################################
 ####### Merge ACS and NATA Health Data
 ##########################################
 
  tar_target(nata_data,
             merge_nata(ats_cancer_loaded, ats_resp_loaded)),
 
 
  
  tar_target(merge_acs_health,
             merge_acs(acs_data_loaded, nata_data)),
  
 ###################################################
 ###### Subset region of interest from merged data
 ###################################################
 
  tar_target(filter_area,
             filter_acs_state(merge_acs_health, states)),
  

  tar_target(filter_facilities_by_state,
             filter_facilities_state(facilities_data_loaded, states)),
 
 
  tar_target(filter_facilities_final,
             filter_facilities_type(filter_facilities_by_state, mill_type)),
 
 
  tar_target(filter_tri_facilities,
             filter_tri_facilities_states_industry(tri_facilities_data_loaded,
                                                   states,
                                                   tri_industry_sector)),
 
 
 
  
 ############################
 ##### Create Leaflet Map
 ###########################
 
  
  tar_target(create_leaflet,
             create_leaflet_map(filter_area,
                                filter_facilities_final)),
  
 
 ############################
 #### Export Leaflet to HTML
 ############################ 
 
 
  tar_target(export_leaflet_as_html,
             export_leaflet_map(create_leaflet,
                                map_title = map_title),
             format = 'file'),
  


 ###############################################################################
 # Biomass Proximity Analysis
##################################


 tar_target(fac_map, prep_facilities(filter_facilities_final,
                                             ID_column_name,
                                             longitude_col_name,
                                             latitude_col_name)),




  tar_target(urban_tracts_loaded, load_urban_tracts()),

  tar_target(data_ct_loaded, gen_acs_data_ct(acs_data_loaded)),

  tar_target(shp_loaded, prep_acs_geometry(data_ct_loaded, urban_tracts_loaded)),

  tar_target(gen_bufferzone, create_buffer_zone(fac_map, buffer_radius_mi, shp_loaded)),

  tar_target(gen_sq_miles, gen_sq_miles(shp_loaded)),
  
  
  
  tar_target(acs_health_table, gen_acs_health_table(data_ct_loaded,
                                                    gen_sq_miles,
                                                    urban_tracts_loaded,
                                                    nata_data,
                                                    geography_column_name,
                                                    states
                                                    )),

  tar_target(fac_dem_pre, merge_facility_buffer(fac_map, gen_bufferzone)),

  tar_target(fac_dem_mid, gen_fac_dem_mid(fac_dem_pre, acs_health_table)),

  tar_target(fac_dem_table, gen_fac_dem_table(fac_dem_mid, gen_sq_miles)),

  tar_target(write_facility_dem_table, write_table(fac_dem_table, final_table_name))



)


