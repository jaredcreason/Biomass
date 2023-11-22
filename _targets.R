
# Biomass/_targets.R

library(targets)
library(tarchetypes)

source('R/packages.R')

tar_source()


tar_option_set(
  packages=packages
)

tar_plan(

  #tar_target(acs_data, 'data/acs_data/acs_data_2021_block group.Rdata', format = 'file'),
  #tar_target(facilities_data, 'data/All_mills_ACS.xlsx', format = 'file'),
  #tar_target(ats_cancer_data, 'data/ats_data/2019_National_CancerRisk_by_tract_poll.xlsx', format = 'file'),
  #tar_target(ats_resp_data, 'data/ats_data/2019_National_RespHI_by_tract_poll.xlsx', format = 'file'),
  
  
  
  #tar_target(load_acs, load_acs_data(acs_data)),
  #tar_target(load_facilities_data, load_facilities_data(facilities_data)),
  #tar_target(load_ats_cancer, load_ats_cancer(ats_cancer_data)),
  #tar_target(load_ats_resp, load_ats_resp(ats_resp_data)),
  
  

  
  #ar_target(merge_acs_health, create_table_2(data, load_ats_cancer, load_ats_resp))

  tar_target
  
  )










