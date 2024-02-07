
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
  states <- c('LA'),
 
 
  # Enter desired mill-type, options include:
 # "pellet", "plywood/veneer", "lumber", "pulp/paper", "chip", or "OSB" 
  
<<<<<<< Updated upstream
  mill_type <- c('pulp/paper'),
=======
<<<<<<< Updated upstream
  mill_type <- c('pulp/paper'),
=======
  mill_type <- c('pellet'),
>>>>>>> Stashed changes
>>>>>>> Stashed changes
 
 
 tri_industry_sector <- c('Wood Products'),
 
 # Options Include:
 # [1] "Plastics and Rubber"               "Machinery"                         "Petroleum Bulk Terminals"          "Chemicals"                        
 # [5] "Food"                              "Fabricated Metals"                 "Transportation Equipment"          "Nonmetallic Mineral Product"      
 # [9] "Primary Metals"                    "Electric Utilities"                "Electrical Equipment"              "Petroleum"                        
 # [13] "Paper"                             "Hazardous Waste"                   "Beverages"                         "Wood Products"                    
 # [17] "Other"                             "Chemical Wholesalers"              "Coal Mining"                       "Miscellaneous Manufacturing"      
 # [21] "Furniture"                         "Metal Mining"                      "Computers and Electronic Products" "Printing"                         
 # [25] "Textiles"                          "Textile Product"                   "Tobacco"                           "Leather"                          
 # [29] "Publishing"                        "Apparel" 
 
  
  # Enter desired file name of output .html file
#  map_title <- 'US_NATL_mills_map',

 
 ##############################################################
 
 # Proximity Analysis Set-Up
 

<<<<<<< Updated upstream
final_table_name = 'LA_all_tri',
=======
<<<<<<< Updated upstream
final_table_name = 'LA_all_tri',
=======
final_table_name = 'USA_pellet',
>>>>>>> Stashed changes
>>>>>>> Stashed changes
 
 #geography_column_name = '8. ST',
 

 #### Uncomment for LURA All Mills

<<<<<<< Updated upstream
  #longitude_col_name = 'Longitude',

 #latitude_col_name = 'Latitude',
=======
<<<<<<< Updated upstream
  #longitude_col_name = 'Longitude',

 #latitude_col_name = 'Latitude',
=======
  longitude_col_name = 'Longitude',

  latitude_col_name = 'Latitude',
>>>>>>> Stashed changes
>>>>>>> Stashed changes



### Uncomment for TRI Facilities
# 
  #longitude_col_name = '13. LONGITUDE',
#  
  # latitude_col_name = '12. LATITUDE',
#  

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

  tar_target(places_data,
             'data/places_data/places_health_outcomes_ct.csv',
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

  tar_target(places_loaded,
             load_places(places_data)),
  
  tar_target(facilities_data_loaded,
             load_facilities_data(facilities_data)),

  tar_target(tri_facilities_data_loaded,
             load_tri_facilities_data(tri_facilities_data)),

  
  
 #########################################
 ####### Merge ACS and NATA Health Data
 ##########################################
 
  tar_target(nata_data,
             merge_nata(ats_cancer_loaded, ats_resp_loaded, places_loaded)),
 
 
  
  tar_target(merge_acs_health,
             merge_acs(acs_data_loaded, nata_data, places_loaded)),

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
  tar_target(filter_facilities_by_both,
             filter_facilities_type(filter_facilities_by_state, mill_type)),


###




  tar_target(filter_tri_by_state, filter_tri_state(tri_facilities_data_loaded, states)),


  tar_target(filter_tri_by_industry, filter_tri_industry(tri_facilities_data_loaded, tri_industry_sector)),

 
  tar_target(filter_tri_facilities_by_both,
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

<<<<<<< Updated upstream
=======
<<<<<<< Updated upstream
>>>>>>> Stashed changes
tar_target(fac_lat_lon, gen_fac_lat_lon(filter_tri_by_state,
                                        latitude_col_name = latitude_col_name,
                                        longitude_col_name = longitude_col_name)),

tar_target(fac_sf, gen_fac_sf(filter_tri_by_state,
<<<<<<< Updated upstream
=======
=======
tar_target(fac_lat_lon, gen_fac_lat_lon(filter_facilities_by_milltype,
                                        latitude_col_name = latitude_col_name,
                                        longitude_col_name = longitude_col_name)),

tar_target(fac_sf, gen_fac_sf(filter_facilities_by_milltype,
>>>>>>> Stashed changes
>>>>>>> Stashed changes
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

##############

  tar_target(bufferzone_1mi, create_buffer_zone(fac_map,
                                                radius_mi = 1,
                                                shp)),

  tar_target(bufferzone_3mi, create_buffer_zone(fac_map,
                                                radius_mi = 3,
                                                shp)),

  tar_target(bufferzone_5mi, create_buffer_zone(fac_map,
                                                radius_mi = 5,
                                                shp)),

  tar_target(bufferzone_10mi, create_buffer_zone(fac_map,
                                                 radius_mi = 10,
                                                 shp)),

###################

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
#######################

  tar_target(fac_dem_pre_1mi, merge_facility_buffer(fac_map, bufferzone_1mi)),
tar_target(fac_dem_pre_3mi, merge_facility_buffer(fac_map, bufferzone_3mi)),
tar_target(fac_dem_pre_5mi, merge_facility_buffer(fac_map, bufferzone_5mi)),
tar_target(fac_dem_pre_10mi, merge_facility_buffer(fac_map, bufferzone_10mi)),




########################
  tar_target(fac_dem_mid_1mi, gen_fac_dem_mid(fac_dem_pre_1mi, natl_acs_health_table)),
tar_target(fac_dem_mid_3mi, gen_fac_dem_mid(fac_dem_pre_3mi, natl_acs_health_table)),
tar_target(fac_dem_mid_5mi, gen_fac_dem_mid(fac_dem_pre_5mi, natl_acs_health_table)),
tar_target(fac_dem_mid_10mi, gen_fac_dem_mid(fac_dem_pre_10mi, natl_acs_health_table)),




########################
  tar_target(fac_dem_table_1mi, gen_fac_dem_table(fac_dem_mid_1mi, sq_miles)),
tar_target(fac_dem_table_3mi, gen_fac_dem_table(fac_dem_mid_3mi, sq_miles)),
tar_target(fac_dem_table_5mi, gen_fac_dem_table(fac_dem_mid_5mi, sq_miles)),
tar_target(fac_dem_table_10mi, gen_fac_dem_table(fac_dem_mid_10mi, sq_miles)),






#########################################################
########### Conduct Proximity Analysis
##################################################

 comparison_vars <- c("white_pct",
                      'minority_black',
                      'minority_other',
                      'minority_hispanic',
                      "income",
                      "pov99",
                      "pov50",
                      "total_risk",
                      "total_risk_resp",
                      "asthma_prev"),
 
 
 # descriptions of the comparison variables to be included in the tables
desc_vars <- c("% White",
               "% Black or African American (race)",
               "% Other (race)",
               "% Hispanic (ethnic origin)",
               "Median Income (1k 2021$)",
               "% Below Poverty Line",
               "% Below Half the Poverty Line",
               "Total Cancer Risk (per million)",
               'Total Respiratory Risk (hazard quotient)',
               'Asthma Prevalence (% Pop.)'),
 
 
  tar_target(fac_dem_comp_vars_1mi, add_comp_vars(fac_dem_mid_1mi)),
tar_target(fac_dem_comp_vars_3mi, add_comp_vars(fac_dem_mid_3mi)),
tar_target(fac_dem_comp_vars_5mi, add_comp_vars(fac_dem_mid_5mi)),
tar_target(fac_dem_comp_vars_10mi, add_comp_vars(fac_dem_mid_10mi)),


   tar_target(summary_means_table_natl, gen_summary_means_table_natl(desc_vars,
                                               comparison_vars,
                                               natl_table = natl_acs_health_table)),
 


 tar_target(summary_means_buffer_1mi, gen_summary_means_table_buffer(desc_vars,
                                                                     comparison_vars,
                                                                     fac_dem_table = fac_dem_comp_vars_1mi,
                                                                     buffer_radius = 1)),
tar_target(summary_means_buffer_3mi, gen_summary_means_table_buffer(desc_vars,
                                                                    comparison_vars,
                                                                    fac_dem_table = fac_dem_comp_vars_3mi,
                                                                    buffer_radius = 3)),
tar_target(summary_means_buffer_5mi, gen_summary_means_table_buffer(desc_vars,
                                                                    comparison_vars,
                                                                    fac_dem_table = fac_dem_comp_vars_5mi,
                                                                    buffer_radius = 5)),
tar_target(summary_means_buffer_10mi, gen_summary_means_table_buffer(desc_vars,
                                                                    comparison_vars,
                                                                    fac_dem_table = fac_dem_comp_vars_10mi,
                                                                    buffer_radius = 10)),


tar_target(summary_table_list, list(summary_means_buffer_1mi,
                                    summary_means_buffer_3mi,
                                    summary_means_buffer_5mi,
                                    summary_means_buffer_10mi)),


tar_target(final_summary_table, merge_summary_tables(summary_means_table_natl,
                                                      summary_table_list)),

tar_target(export_table_to_html, write_summary_means_table(final_summary_table, final_table_name))

)


##################

 ##################
 
 
 # tar_target(summary_sd_table, gen_summary_sd_table(desc_vars,
 #                                             comparison_vars,
 #                                             natl_table = natl_acs_health_table,
 #                                             state_table = acs_health_table,
 #                                             fac_dem_table = fac_dem_comp_vars)),
 # 
 # 
 # 
 # tar_target(write_summary_sd_table, write_summary_sd_table(summary_sd_table, final_table_name))
