
# Biomass/_targets.R

######################################
### How to Run this Repository
######################################

# FIRST TIME ONLY: Script will query ACS Data from Census API
# Runtime: (approx. 90 minutes)


# Step 1: Load required targets packages
library(targets)
library(tarchetypes)



# Step 2: Complete Set-up by altering strings by state and facility

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
 # states <- c('AR','LA','MS','AL','GA','FL','TN','SC', 'NC'),
  states <- c('GA'),
 
 
  # Enter desired mill-type, options include:
 # "pellet", "plywood/veneer", "lumber", "pulp/paper", "chip", or "OSB" 
  
  mill_type <- c('pulp/paper'),
 
 
 tri_industry_sector <- c('Wood Products'),
  
  
  # Enter desired file name of output .html file
#  map_title <- 'US_NATL_mills_map',

 
 ##############################################################
 
 # Proximity Analysis Set-Up
 

 buffer_radius_mi = 1,
 
 final_table_name = 'USA_tri_woodproducts_1mi',
 
 #geography_column_name = '8. ST',
 

 #### Uncomment for LURA All Mills

 # longitude_col_name = 'Longitude',

 # latitude_col_name = 'Latitude',



### Uncomment for TRI Facilities

  longitude_col_name = '13. LONGITUDE',
 
  latitude_col_name = '12. LATITUDE',
 

# End of Set-up

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

 ###################################################################
 ##### Subset region or industry of interest from facility dataset
 ######################################################################

  #tar_target(filter_area,
   #          filter_acs_state(merge_acs_health, states)),


 # Filters LURA Mills by State..
  tar_target(filter_facilities_by_state,
             filter_facilities_state(facilities_data_loaded, states)),

 # By mill type..
  tar_target(filter_facilities_by_milltype,
           filter_facilities_type(facilities_data_loaded, mill_type)),

 # By both
  tar_target(filter_facilities_final,
             filter_facilities_type(filter_facilities_by_state, mill_type)),


###




  tar_target(filter_tri_by_state, filter_tri_state(tri_facilities_data_loaded, states)),

  tar_target(filter_tri_by_industry, filter_tri_industry(tri_facilities_data_loaded, tri_industry_sector)),

 
  tar_target(filter_tri_facilities_final,
             filter_tri_facilities_states_industry(tri_facilities_data_loaded,
                                                   states,
                                                   tri_industry_sector)),
 
 
 
  
 ############################
 ##### Create Leaflet Map
 ###########################
 
  
  # tar_target(create_leaflet,
             # create_leaflet_map(filter_area,
                                # filter_facilities_final)),
  
 
 ############################
 #### Export Leaflet to HTML
 ############################ 
 
 
  # tar_target(export_leaflet_as_html,
             # export_leaflet_map(create_leaflet,
                                # map_title = map_title),
             # format = 'file'),
  


 ###############################################################################
 # Biomass Proximity Analysis
##################################


 # Prep Proximity Analysis

## Create fac map

 tar_target(urban_areas, urban_areas()),
 tar_target(uac, gen_uac(urban_areas)),

tar_target(fac_lat_lon, gen_fac_lat_lon(filter_tri_by_industry,
                                        latitude_col_name = latitude_col_name,
                                        longitude_col_name = longitude_col_name)),

tar_target(fac_sf, gen_fac_sf(filter_tri_by_industry,
                              latitude_col_name = latitude_col_name,
                              longitude_col_name = longitude_col_name)),

tar_target(fac_sf_urban, gen_fac_sf_urban(fac_sf, uac)),

tar_target(fac_sf_rural, gen_fac_sf_rural(fac_sf, fac_sf_urban)),

 tar_target(fac_map, gen_fac_map(fac_sf,
                                 fac_sf_rural,
                                 fac_lat_lon)),




#######################################################################



  tar_target(urban_tracts, load_urban_tracts()),

  tar_target(data_ct, gen_acs_data_ct(acs_data_loaded)),

  tar_target(shp, prep_acs_geometry(data_ct, urban_tracts)),

  tar_target(bufferzone, create_buffer_zone(fac_map,
                                                buffer_radius_mi,
                                                shp)),



  tar_target(sq_miles, gen_sq_miles(shp)),

  tar_target(natl_acs_health_table, gen_natl_acs_health_table(data_ct,
                                                              sq_miles,
                                                              urban_tracts,
                                                              nata_data)),
  
  
  
  tar_target(acs_health_table, gen_acs_health_table(data_ct,
                                                    sq_miles,
                                                    urban_tracts,
                                                    nata_data,
                                                    states
                                                    )),

  tar_target(fac_dem_pre, merge_facility_buffer(fac_map, bufferzone)),

  tar_target(fac_dem_mid, gen_fac_dem_mid(fac_dem_pre, natl_acs_health_table)),

  tar_target(fac_dem_table, gen_fac_dem_table(fac_dem_mid, sq_miles)),

  tar_target(write_facility_dem_table, write_fac_dem_table(fac_dem_table, final_table_name)),

#########################################################
########### Conduct Proximity Analysis
##################################################

comparison_vars <- c("white_pct",'minority_black','minority_other','minority_hispanic',
                    "income",
                    "pov99","pov50",
                    "total_risk","total_risk_resp"),


# descriptions of the comparison variables to be included in the tables
desc_vars <- c("% White","% Black or African American ","% Other","% Hispanic",
              "Median Income [1,000 2019$]",
              "% Below Poverty Line","% Below Half the Poverty Line",
              "Total Cancer Risk (per million)",
              'Total Respiratory (hazard quotient)'),


  tar_target(fac_dem_comp_vars, add_comp_vars(fac_dem_table)),

  tar_target(summary_means_table, gen_summary_means_table(desc_vars,
                                              comparison_vars,
                                              natl_table = natl_acs_health_table,
                                              state_table = natl_acs_health_table,
                                              fac_dem_table = fac_dem_comp_vars)),

tar_target(write_summary_means_table, write_summary_means_table(summary_means_table, final_table_name)),


##################


tar_target(summary_sd_table, gen_summary_sd_table(desc_vars,
                                            comparison_vars,
                                            natl_table = natl_acs_health_table,
                                            state_table = natl_acs_health_table,
                                            fac_dem_table = fac_dem_comp_vars)),



tar_target(write_summary_sd_table, write_summary_sd_table(summary_sd_table, final_table_name))

)

