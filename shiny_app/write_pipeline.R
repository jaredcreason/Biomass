# Write _targets.R script to project directory.

pipeline <- "
library(targets)
library(tarchetypes)

source('packages.R')

tar_source()
load_facilties_data <- function(facilities_filepath, column){
  
  facs <- read_csv(facilities_filepath) |>
  mutate(Label = column)

  return(facs)
}

tar_option_set(packages = c('tidyverse', 'leaflet', 'htmlwidgets'))

tar_plan(
 
  table_title = '%s',
  

 tar_target(facilities_filepath,
            '%s',
            format = 'file'),
 
 
 tar_target(ats_cancer_data,
            'data/ats_data/2019_National_CancerRisk_by_tract_poll.xlsx',
            format = 'file'),

 tar_target(ats_resp_data,
            'data/ats_data/2019_National_RespHI_by_tract_poll.xlsx',
            format = 'file'),
 
 tar_target(places_data,
            'data/places_data/places_data_ct_2021.csv',
            format = 'file'),

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
  
  ##################################
  

tar_target(
  facilities,load_facilties_data(facilities_filepath, '%s')
  
),
 
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
  
  tar_target(urban_areas, urban_areas(year = 2019)),
  tar_target(uac, gen_uac(urban_areas)),
  
  tar_target(fac_lat_lon, gen_fac_lat_lon(facilities)),

  tar_target(fac_sf, gen_fac_sf(facilities)),
  
  tar_target(fac_sf_urban, gen_fac_sf_urban(fac_sf, uac)),
  
  tar_target(fac_sf_rural, gen_fac_sf_rural(fac_sf, fac_sf_urban)),
  
  tar_target(fac_map, gen_fac_map(fac_sf,
                                  fac_sf_rural,
                                  fac_lat_lon)),

  tar_target(urban_tracts, load_urban_tracts()),
  
  tar_target(data_ct, gen_acs_data_ct(acs_data_loaded)),
  
  tar_target(shp, prep_acs_geometry(data_ct, urban_tracts)),
  
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

  comparison_vars <- c(
    'white_pct',
    'minority_black',
    'minority_other',
    'minority_hispanic',
    'income',
    'pov99',
    'pov50',
    'total_risk',
    'total_risk_resp',
    'cancer_prev',
    'asthma_prev',
    'chd_prev'
    #,'health_ins'
  ),

  desc_vars <- c(
    '%% White',
    '%% Black or African American (race)',
    '%% Other (race)',
    '%% Hispanic (ethnic origin)',
    'Median Income (1k 2019$)',
    '%% Below Poverty Line',
    '%% Below Half the Poverty Line',
    'Total Cancer Risk (per million)',
    'Total Respiratory Risk (hazard quotient)',
    'Cancer Prevalence (exl. Skin) (%% Pop.)',
    'Asthma Prevalence (%% Pop.)',
    'Coronary Heart Disease Prevalence (%% Pop.)'
    #,'Lack Health Insurance (%% Pop.)'
  ),
  

  tar_target(fac_dem_comp_vars_1mi, add_comp_vars(fac_dem_mid_1mi)),
  tar_target(fac_dem_comp_vars_3mi, add_comp_vars(fac_dem_mid_3mi)),
  tar_target(fac_dem_comp_vars_5mi, add_comp_vars(fac_dem_mid_5mi)),
  tar_target(fac_dem_comp_vars_10mi, add_comp_vars(fac_dem_mid_10mi)),
 
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
  )
  
)


    
    "