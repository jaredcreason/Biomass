
source('packages.R')


# Functions for loading and stacking NYC .rds files

load_data = function(folder){
  
  files = list.files(folder) # folder with clean data csvs
  
  data_list = list() # create blank list to save off data from each csv
  
  for(i in files) {
    name = paste(tools::file_path_sans_ext(i))
    data = readRDS(paste0(folder,i))
    data_list[[name]] = data
  }
  
  final_data = bind_rows(data_list)
  return(final_data)
  
}






merge_data_sets <-  function(folder) {
  
  directories = dir_ls(folder, type = 'directory') # folder 
  
  data_list = list() # create blank list to save off data from each csv
  
  for(i in directories) {
    name = i
    data = load_data(paste0(i,'/'))
    data = data %>% st_drop_geometry() %>% select(TRACT, variable, estimate)
    print(length(unique(data$TRACT)))
    data_list[[name]] = data}
  
  final_data = data_list
  
  return(final_data)
  
}




##############################

# Load and stack nyc downscaled data

nyc_data <- merge_data_sets('data/nyc_fusion')

nyc_dataset <- nyc_data$`data/nyc_fusion/ACS_JWMNP_NYC`

nyc_tracts <- unique(nyc_dataset$TRACT)

nyc_tall <- bind_rows(nyc_data)%>% rename(tract = TRACT) %>% distinct()

nyc_clean <- nyc_tall %>% filter(tract %in% nyc_tracts)

nyc_tall_distinct <- nyc_clean %>% distinct() 



nyc_wide <- pivot_wider(
  nyc_tall_distinct,
  names_from = 'variable',
  values_from = 'estimate') %>% unnest(everything())



########################
# Load RECS data



custom_vars <- c('insec', 'noheat', 'noac', 'ej40_eng_flag')

recs2020_tract <-
  readRDS("data/nyc_fusion/RECS_2020_tract10_national.rds") %>%
  select(., c('lhs', 'rhs', 'tract10', 'est', 'level')) %>%
  mutate(tract10 = as.character(tract10))

# pull out custom variables, get true values
recs2020_tract_custom <-        
  recs2020_tract %>% filter(lhs %in% custom_vars) %>% filter(level == TRUE) %>% mutate(est = 100*est) %>%
  rename(tract = tract10,
         variable = lhs,
         estimate = est) %>%
  select(tract, variable, estimate)


# pull out non-custom variables
recs2020_tract_default <-
  recs2020_tract %>% filter(!lhs %in% custom_vars) %>% mutate(est = 100*est) %>%
  rename(tract =tract10,
         variable = lhs,
         estimate = est) %>%
  select(tract, variable, estimate)


# stack together
recs2020_tall <- recs2020_tract_default %>% bind_rows(recs2020_tract_custom)


recs_2020_wide <- recs2020_tall %>%  pivot_wider(names_from = 'variable',
                                                 values_from = 'estimate') %>%
  filter(tract %in% nyc_tracts)

##############


nyc_joined <- left_join(recs_2020_wide,nyc_wide, by = 'tract')

##############


#write.xlsx(nyc_joined,'output/nyc_fusion/nyc_joined_table.xlsx')





