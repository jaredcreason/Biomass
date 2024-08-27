

library(targets)
library(tarchetypes)

source('packages.R')

tar_source()
load_facilties_data <- function(facilities_filepath, column) {
facs <- read_csv(facilities_filepath) |>
  mutate(Label = column)

  return(facs)
}


tar_plan(
table_title = 'test_table',


 tar_target(facilities_filepath, 'data/ghgrp_2022_subpart_w.csv', format = 'file'),



tar_target(facilities, load_facilties_data(facilities_filepath, 'facility_id')),


)
