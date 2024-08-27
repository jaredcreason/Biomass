
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
table_title = 'ff',


 tar_target(facilities_filepath, 'C:\Users\dlopez\AppData\Local\Temp\Rtmp2TckVn/1d50d43a5157206b88a1d5c0/0.csv', format = 'file'),



tar_target(facilities, load_facilties_data(facilities_filepath, 'facility_id')),


)


    
    
