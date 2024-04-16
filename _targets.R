

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


tar_option_set(packages = c('tidyverse', 'leaflet', 'htmlwidgets'))


tar_plan(
  ############################################
  ##### Identify Facilities of INterest
  ##########################################
  
  
  
  ## Enter one or multiple U.S. State Abbreviations
  
  states <- c('NC'),
  
  
  # Enter desired mill-type, options include:
  # "pellet", "plywood/veneer", "lumber", "pulp/paper", "chip", or "OSB"
  
  mill_type <- c('pellet'),
  
  
  
  ######################
  ### TRI ONLY FILTERING
  ######################
  tri_industry_sector <- c('Coal Mining'),
  
  # Options Include:
  # [1] "Plastics and Rubber"               "Machinery"                         "Petroleum Bulk Terminals"          "Chemicals"
  # [5] "Food"                              "Fabricated Metals"                 "Transportation Equipment"          "Nonmetallic Mineral Product"
  # [9] "Primary Metals"                    "Electric Utilities"                "Electrical Equipment"              "Petroleum"
  # [13] "Paper"                             "Hazardous Waste"                   "Beverages"                         "Wood Products"
  # [17] "Other"                             "Chemical Wholesalers"              "Coal Mining"                       "Miscellaneous Manufacturing"
  # [21] "Furniture"                         "Metal Mining"                      "Computers and Electronic Products" "Printing"
  # [25] "Textiles"                          "Textile Product"                   "Tobacco"                           "Leather"
  # [29] "Publishing"                        "Apparel"
 
   ###########
  final_file_name = 'nc_pellets_0403',
  table_title = 'NC Pellet Mills',
  
  #### Uncomment for LURA All Mills
  
   longitude_col_name = 'Longitude',
  
   latitude_col_name = 'Latitude',
   
  
  
  ### Uncomment for TRI Facilities
  
  
 #longitude_col_name = '13. LONGITUDE',
  
  #latitude_col_name = '12. LATITUDE',
 
 
 ## HFC Facility data
 #longitude_col_name = 'Long',
 
 #latitude_col_name = 'Lat',
 
  
  
  # End of Set-up
  
  ##############################################################
  
  # Proximity Analysis Set-Up
  
  
  
  ################################
  ###### Establish data file paths
  ################################
 
 
 tar_target(all_mills_data,
            'data/All_mills_ACS.xlsx',
            format = 'file'),
 
 
 tar_target(tri_facilities_data,
            'data/tri_data/tri_2020_us.csv',
            format = 'file'),
 
 tar_target(sch_h_facilities,
            'data/HFC Reclamation Facilities_3.29.2024_filtered.xlsx',
            format = 'file'),
 
 #############################
 
 tar_target(
   ats_cancer_data,
   'data/ats_data/2019_National_CancerRisk_by_tract_poll.xlsx',
   format = 'file'
 ),
 
 
 tar_target(ats_resp_data,
            'data/ats_data/2019_National_RespHI_by_tract_poll.xlsx',
            format = 'file'),
 
 tar_target(places_data,
            'data/places_data/places_data_ct_2021.csv',
            format = 'file'),
 
 
 
  #####################################
  ####### Load data using functions
  ######################################
 
 
 
 tar_target(acs_data_loaded,
            load_acs_data(acs_data_filepath)),
 
 tar_target(ats_cancer_loaded,
            load_ats_cancer(ats_cancer_data)),
 
 
 tar_target(ats_resp_loaded,
            load_ats_resp(ats_resp_data)),
 
 tar_target(places_cancer_loaded,
            load_places_cancer(places_data)),
 
 tar_target(places_asthma_loaded,
            load_asthma(places_data)),
 
 tar_target(places_chd_loaded,
            load_chd(places_data)),
 
# tar_target(places_health_ins_loaded,
 #           load_health_ins(places_data)),
 
  
  ##################################
  
 tar_target(sch_h_facilities_loaded,
            load_sch_h_facilities(sch_h_facilities)),
 
 tar_target(
    all_mills_loaded,
    load_all_mills(all_mills_data)
  ),
  
  tar_target(
    tri_facilities_data_loaded,
    load_tri_facilities_data(tri_facilities_data)
  ),
  
  
  
  #########################################
  ####### Merge ACS and Health Data
  ##########################################
 
 
 tar_target(
   health_data,
   merge_health(
     ats_cancer_loaded,
     ats_resp_loaded,
     places_cancer_loaded,
     places_asthma_loaded,
     places_chd_loaded
     #,places_health_ins_loaded
   )
 ),
 
  
  
  # tar_target(merge_acs_health,
  #            merge_acs(acs_data_loaded, health_data)),
  
  ###################################################################
  ##### Subset region or industry of interest from facility dataset
  ######################################################################
  
  
  # Filters LURA Mills by State..
  tar_target(
    filter_mills_by_state,
    filter_mills_state(all_mills_loaded, states)
  ),
  
  # By mill type..
  tar_target(
    filter_mills_by_type,
    filter_mills_type(all_mills_loaded, mill_type)
  ),
  
  # Or by both
  tar_target(
    filter_mills_by_both,
    filter_mills_type(filter_mills_by_state, mill_type)
  ),
  
  
  #########################################
  
  
  tar_target(
    filter_tri_by_state,
    filter_tri_state(tri_facilities_data_loaded, states)
  ),
  
  
  tar_target(
    filter_tri_by_industry,
    filter_tri_industry(tri_facilities_data_loaded, tri_industry_sector)
  ),
  
  
  tar_target(
    filter_tri_facilities_by_both,
    filter_tri_facilities_states_industry(tri_facilities_data_loaded,
                                          states,
                                          tri_industry_sector)
  ),
  ########################################################
 
 ## Last step, input final facilities target:
 
 tar_target(facilities, filter_mills_by_both),
 
 ## ...now save and tar_make()

 
  ###############################################################################
  # Biomass Proximity Analysis
  ##################################
  
  
  # Prep Proximity Analysis
  
  ## Create facility tables with demographics
  
  tar_target(urban_areas, urban_areas(year = 2019)),
  tar_target(uac, gen_uac(urban_areas)),
  
  tar_target(
    fac_lat_lon,
    gen_fac_lat_lon(
      facilities,
      latitude_col_name = latitude_col_name,
      longitude_col_name = longitude_col_name
    )
  ),
  
  
  
  tar_target(
    fac_sf,
    gen_fac_sf(
      facilities,
      latitude_col_name = latitude_col_name,
      longitude_col_name = longitude_col_name
    )
  ),
  
  tar_target(fac_sf_urban, gen_fac_sf_urban(fac_sf, uac)),
  
  tar_target(fac_sf_rural, gen_fac_sf_rural(fac_sf, fac_sf_urban)),
  
  tar_target(fac_map, gen_fac_map(fac_sf,
                                  fac_sf_rural,
                                  fac_lat_lon)),
  
  #######################################################################
  
  tar_target(urban_tracts, load_urban_tracts()),
  
  tar_target(data_ct, gen_acs_data_ct(acs_data_loaded)),
  
  tar_target(shp, prep_acs_geometry(data_ct, urban_tracts)),
  
  #######################################################################
  
  tar_target(bufferzone_1mi, create_buffer_zone(fac_map,
                                                radius_mi = 1,
                                                shp)),
  
  tar_target(bufferzone_3mi, create_buffer_zone(fac_map,
                                                radius_mi = 3,
                                                shp)),
  
  tar_target(bufferzone_5mi, create_buffer_zone(fac_map,
                                                radius_mi = 5,
                                                shp)),
  
  tar_target(
    bufferzone_10mi,
    create_buffer_zone(fac_map,
                       radius_mi = 10,
                       shp)
  ),
  
  #######################################################################
  
  tar_target(sq_miles, gen_sq_miles(shp)),
  
  tar_target(
    natl_acs_health_table,
    gen_natl_acs_health_table(data_ct,
                              sq_miles,
                              urban_tracts,
                              health_data)
  ),
  
  
  
  tar_target(
    acs_health_table,
    gen_acs_health_table(data_ct,
                         sq_miles,
                         urban_tracts,
                         health_data,
                         states)
  ),
  #######################################################################
  
  tar_target(
    fac_dem_pre_1mi,
    merge_facility_buffer(fac_map, bufferzone_1mi)
  ),
  tar_target(
    fac_dem_pre_3mi,
    merge_facility_buffer(fac_map, bufferzone_3mi)
  ),
  tar_target(
    fac_dem_pre_5mi,
    merge_facility_buffer(fac_map, bufferzone_5mi)
  ),
  tar_target(
    fac_dem_pre_10mi,
    merge_facility_buffer(fac_map, bufferzone_10mi)
  ),
  
  ########################
  
  tar_target(
    fac_dem_mid_1mi,
    gen_fac_dem_mid(fac_dem_pre_1mi, natl_acs_health_table)
  ),
  tar_target(
    fac_dem_mid_3mi,
    gen_fac_dem_mid(fac_dem_pre_3mi, natl_acs_health_table)
  ),
  tar_target(
    fac_dem_mid_5mi,
    gen_fac_dem_mid(fac_dem_pre_5mi, natl_acs_health_table)
  ),
  tar_target(
    fac_dem_mid_10mi,
    gen_fac_dem_mid(fac_dem_pre_10mi, natl_acs_health_table)
  ),
  
  ########################


  
  tar_target(
    fac_dem_table_1mi,
    gen_fac_dem_table(fac_dem_mid_1mi, sq_miles)
  ),
  tar_target(
    fac_dem_table_3mi,
    gen_fac_dem_table(fac_dem_mid_3mi, sq_miles)
  ),
  tar_target(
    fac_dem_table_5mi,
    gen_fac_dem_table(fac_dem_mid_5mi, sq_miles)
  ),
  tar_target(
    fac_dem_table_10mi,
    gen_fac_dem_table(fac_dem_mid_10mi, sq_miles)
  ),


# Get bufferzone populations

tar_target(buffer_pop_table_1mi, gen_buffer_pop_table(fac_dem_mid_1mi)),
tar_target(buffer_pop_table_3mi, gen_buffer_pop_table(fac_dem_mid_3mi)),
tar_target(buffer_pop_table_5mi, gen_buffer_pop_table(fac_dem_mid_5mi)),
tar_target(buffer_pop_table_10mi, gen_buffer_pop_table(fac_dem_mid_10mi)),

tar_target(mean_buffer_pop_1mi, calc_mean_buffer_pop(buffer_pop_table_1mi)),
tar_target(mean_buffer_pop_3mi, calc_mean_buffer_pop(buffer_pop_table_3mi)),
tar_target(mean_buffer_pop_5mi, calc_mean_buffer_pop(buffer_pop_table_5mi)),
tar_target(mean_buffer_pop_10mi, calc_mean_buffer_pop(buffer_pop_table_10mi)),


tar_target(median_buffer_pop_1mi, calc_median_buffer_pop(buffer_pop_table_1mi)),
tar_target(median_buffer_pop_3mi, calc_median_buffer_pop(buffer_pop_table_3mi)),
tar_target(median_buffer_pop_5mi, calc_median_buffer_pop(buffer_pop_table_5mi)),
tar_target(median_buffer_pop_10mi, calc_median_buffer_pop(buffer_pop_table_10mi)),











#########################
  #########################################################
  ########### Conduct Proximity Analysis
  ##################################################
  
  comparison_vars <- c(
    "white_pct",
    "minority_black",
    "minority_other",
    "minority_hispanic",
    "income",
    "pov99",
    "pov50",
    "total_risk",
    "total_risk_resp",
    "cancer_prev",
    "asthma_prev",
    "chd_prev"
    #,"health_ins"
  ),
  
  
  # descriptions of the comparison variables to be included in the tables
  desc_vars <- c(
    "% White",
    "% Black or African American (race)",
    "% Other (race)",
    "% Hispanic (ethnic origin)",
    "Median Income (1k 2019$)",
    "% Below Poverty Line",
    "% Below Half the Poverty Line",
    "Total Cancer Risk (per million)",
    "Total Respiratory Risk (hazard quotient)",
    "Cancer Prevalence (exl. Skin) (% Pop.)",
    "Asthma Prevalence (% Pop.)",
    "Coronary Heart Disease Prevalence (% Pop.)"
    #,"Lack Health Insurance (% Pop.)"
  ),
  
  # Add comparison variables to facility demographic tables
  
  tar_target(fac_dem_comp_vars_1mi, add_comp_vars(fac_dem_mid_1mi)),
  tar_target(fac_dem_comp_vars_3mi, add_comp_vars(fac_dem_mid_3mi)),
  tar_target(fac_dem_comp_vars_5mi, add_comp_vars(fac_dem_mid_5mi)),
  tar_target(fac_dem_comp_vars_10mi, add_comp_vars(fac_dem_mid_10mi)),
  
  #######################################################################
  
  tar_target(
    summary_means_table_natl,
    gen_summary_means_table_natl(desc_vars,
                                 comparison_vars,
                                 natl_table = natl_acs_health_table)
  ),
  
  
  
  tar_target(
    summary_means_buffer_1mi,
    gen_summary_means_table_buffer(
      desc_vars,
      comparison_vars,
      fac_dem_table = fac_dem_comp_vars_1mi,
      buffer_radius = 1
    )
  ),
  tar_target(
    summary_means_buffer_3mi,
    gen_summary_means_table_buffer(
      desc_vars,
      comparison_vars,
      fac_dem_table = fac_dem_comp_vars_3mi,
      buffer_radius = 3
    )
  ),
  tar_target(
    summary_means_buffer_5mi,
    gen_summary_means_table_buffer(
      desc_vars,
      comparison_vars,
      fac_dem_table = fac_dem_comp_vars_5mi,
      buffer_radius = 5
    )
  ),
  tar_target(
    summary_means_buffer_10mi,
    gen_summary_means_table_buffer(
      desc_vars,
      comparison_vars,
      fac_dem_table = fac_dem_comp_vars_10mi,
      buffer_radius = 10
    )
  ),
  
  
  tar_target(
    summary_table_list,
    list(
      summary_means_buffer_1mi,
      summary_means_buffer_3mi,
      summary_means_buffer_5mi,
      summary_means_buffer_10mi
    )
  ),
  
  
  tar_target(
    final_summary_table,
    merge_summary_tables(summary_means_table_natl,
                         summary_table_list)
  ),
  
  tar_target(
    export_means_table_to_html,
    write_summary_means_table(final_summary_table,
                              final_file_name,
                              table_title,
                              fac_sf_rural = fac_sf_rural)
  ),
  

###########################################################
## Standard Deviations Table
######################################################


tar_target(
  summary_sd_table_natl,
  gen_summary_sd_table_natl(desc_vars,
                               comparison_vars,
                               natl_table = natl_acs_health_table)
),



tar_target(
  summary_sd_buffer_1mi,
  gen_summary_sd_table_buffer(
    desc_vars,
    comparison_vars,
    fac_dem_table = fac_dem_comp_vars_1mi,
    buffer_radius = 1
  )
),
tar_target(
  summary_sd_buffer_3mi,
  gen_summary_sd_table_buffer(
    desc_vars,
    comparison_vars,
    fac_dem_table = fac_dem_comp_vars_3mi,
    buffer_radius = 3
  )
),
tar_target(
  summary_sd_buffer_5mi,
  gen_summary_sd_table_buffer(
    desc_vars,
    comparison_vars,
    fac_dem_table = fac_dem_comp_vars_5mi,
    buffer_radius = 5
  )
),
tar_target(
  summary_sd_buffer_10mi,
  gen_summary_sd_table_buffer(
    desc_vars,
    comparison_vars,
    fac_dem_table = fac_dem_comp_vars_10mi,
    buffer_radius = 10
  )
),


tar_target(
  summary_sd_table_list,
  list(
    summary_sd_buffer_1mi,
    summary_sd_buffer_3mi,
    summary_sd_buffer_5mi,
    summary_sd_buffer_10mi
  )
),


tar_target(
  final_summary_sd_table,
  merge_summary_tables(summary_sd_table_natl,
                       summary_sd_table_list)
),

tar_target(
  export_sd_table_to_html,
  write_summary_sd_table(final_summary_sd_table,
                            paste0(final_file_name,'_sd'),
                            table_title,
                         fac_sf_rural = fac_sf_rural)
)


)

# End of Pipeline
##################
