library(fusionModel)
library(fusionData)
library(tigris)
library(mapview)
library(tmap)
library(sf)

tmap_mode("view")

###Load geoconconrdance file#########
geo <- fst::read_fst("data/nyc_fusion/geo_concordance.fst", 
                     columns = c("state",'state_postal','county10','tract10','cbsa10')) %>% 
                      filter(cbsa10 %in% c('35620','14460','16980','19100','41860')) %>% 
                      mutate(tract10 = paste0(state,county10,tract10)) %>% 
                       mutate(tract10 = as.character(tract10)) %>%
                      unique()

# Read food results from disk
recs2020_tract <- readRDS("data/nyc_fusion/RECS_2020_tract10_national.rds") %>% 
                  select(.,c('lhs','rhs','tract10','est','level')) %>% 
                  mutate(tract10 = as.character(tract10)) %>%
                  filter(lhs == 'burden' | lhs == 'insec') %>% 
                  left_join(.,geo, by = 'tract10') %>% filter(!is.na(cbsa10))


###Plot insec maps########
recs2020_insec <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
                  select(est,tract10)


###Plot insec maps########
recs2020_bur <- recs2020_tract %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
                select(est,tract10)
  
###Plot burden maps########
###Make map for NYC########
recs2020_insec_NY <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
                     select(est,tract10,cbsa10) %>% filter(cbsa10 == '35620')

nyc_insec <- tracts(cb = TRUE, year = 2019)  %>%
            rename(county10 = COUNTYFP,
                    tract = TRACTCE,
                    state = STATEFP) %>% 
              mutate(
                    tract10 = paste0(state,county10,tract)) %>% 
                    merge(recs2020_insec_NY, by = c('tract10')) %>% rename(insec = est)

map1 <- tm_shape(nyc_insec) + 
  tm_fill(style = "kmeans",col = "insec", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaternyc_insec.png",res = 3000 )


###Make map for Boston########
recs2020_insec_BOS <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '14460')

bos_insec <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_insec_BOS, by = c('tract10')) %>% rename(insec = est)

map1 <- tm_shape(bos_insec) + 
  tm_fill(style = "kmeans",col = "insec", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-71.05, 42.36, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterboston_insec.png")

###Make map for Chicago########
recs2020_insec_CHI  <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '16980')

CHI_insec <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_insec_CHI, by = c('tract10')) %>% rename(insec = est)

map1 <- tm_shape(CHI_insec) + 
  tm_fill(style = "kmeans",col = "insec", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-87.6298, 41.878, 9.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterchicago_insec.png")



###Make map for Dallas ########
recs2020_insec_DAL  <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '19100')

DAL_insec <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_insec_DAL, by = c('tract10')) %>% rename(insec = est)

map1 <- tm_shape(DAL_insec) + 
  tm_fill(style = "kmeans",col = "insec", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-96.92, 32.70, 9.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterdallas_insec.png")




###Make map for SFO ########
recs2020_insec_SFO  <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '41860')

SFO_insec <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_insec_SFO, by = c('tract10')) %>% rename(insec = est)

map1 <- tm_shape(SFO_insec) + 
  tm_fill(style = "kmeans",col = "insec", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-122.4194, 37.774, 9.75))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greatersanfran_insec.png")


###Plot burden maps########
###Make map for NYC########
recs2020_burden_NY <- recs2020_tract %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '35620')

nyc_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_NY, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(nyc_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaternyc_burden.png")


###Make map for Boston########
recs2020_burden_BOS <- recs2020_tract %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '14460')

bos_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_BOS, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(bos_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-71.05, 42.36, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterboston_burden.png")



###Make map for Chicago########
recs2020_burden_CHI  <- recs2020_tract %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '16980')

CHI_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_CHI, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(CHI_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-87.6298, 41.878, 9.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterchicago_burden.png")



###Make map for Dallas ########
recs2020_burden_DAL  <- recs2020_tract  %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '19100')

DAL_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_DAL, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(DAL_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-96.92, 32.70, 9.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterdallas_burden.png")




###Make map for SFO ########
recs2020_burden_SFO  <- recs2020_tract %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '41860')

SFO_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_SFO, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(SFO_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-122.4194, 37.774, 9.75))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greatersanfran_burden.png")



###National maps
###Load geoconconrdance file#########
geo <- fst::read_fst("geo-processed/concordance/geo_concordance.fst", 
                     columns = c("state",'state_postal','county10','tract10','cbsa10')) %>% 
 # filter(cbsa10 %in% c('35620','14460','16980','19100','41860')) %>% 
  mutate(tract10 = paste0(state,county10,tract10)) %>% 
  mutate(tract10 = as.character(tract10)) %>%
  unique()

# Read food results from disk
recs2020_tract <- readRDS("production/UrbanPop/RECS_2020_tract10_national.rds") %>% 
  select(.,c('lhs','rhs','tract10','est','level')) %>% 
  mutate(tract10 = as.character(tract10)) %>%
  filter(lhs == 'burden' | lhs == 'insec') %>% 
  left_join(.,geo, by = 'tract10') %>% filter(!is.na(cbsa10))

recs2020_burden_nat  <- recs2020_tract %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
                        select(est,tract10,cbsa10) 

nat_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_nat, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(nat_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1

map2 <- map1 + tm_view(set.view = c(-122.4194, 37.774, 9.75))
map2







recs2020_burden_nat  <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
  select(est,tract10,cbsa10) 

nat_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_nat, by = c('tract10')) %>% rename(insec = est)

map1 <- tm_shape(nat_burden) + 
  tm_fill(style = "kmeans",col = "insec", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1

map2 <- map1 + tm_view(set.view = c(-122.4194, 37.774, 9.75))
map2


# Read food results from disk
recs2020_tract_insec <- readRDS("production/UrbanPop/RECS_2020_tract10_national.rds") %>% 
  select(.,c('lhs','rhs','tract10','est','level')) %>% 
  mutate(tract10 = as.character(tract10)) %>% filter(level == 'TRUE') %>%
  filter(lhs == 'insec') %>% select(est,tract10) %>% rename(insec = est) 

recs2020_tract_bur <- readRDS("production/UrbanPop/RECS_2020_tract10_national.rds") %>% 
  select(.,c('lhs','rhs','tract10','est','level')) %>% 
  mutate(tract10 = as.character(tract10)) %>%
  filter(lhs == 'burden') %>% select(est,tract10) %>% rename(burden = est) %>% mutate(burden = as.numeric(burden))

median_value <- median(recs2020_tract_bur$burden, na.rm = TRUE)

recs_2020_merge <- merge(recs2020_tract_insec,recs2020_tract_bur, by = 'tract10') %>% 
                   left_join(.,geo, by = 'tract10') %>% 
                   mutate(median_flag = ifelse(burden > median(burden, na.rm = TRUE),'Yes','No'),
                         recs_bur_flag = ifelse(median_flag == "Yes",burden,NA))


###Plot burden maps########
###Make map for NYC########
recs2020_burden_NY <- recs_2020_merge %>%  mutate(recs_bur_flag = 100 *recs_bur_flag) %>% rename(est = recs_bur_flag) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '35620')

nyc_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_NY, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(nyc_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaternyc_insec_medburden.png")


###Make map for Boston########
recs2020_burden_BOS <- recs_2020_merge %>%  mutate(recs_bur_flag = 100 *recs_bur_flag) %>% rename(est = recs_bur_flag) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '14460')

bos_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_BOS, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(bos_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-71.05, 42.36, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterboston_insec_medburden.png")


###Make map for Chicago########
recs2020_burden_CHI  <- recs_2020_merge %>%  mutate(recs_bur_flag = 100 *recs_bur_flag) %>% rename(est = recs_bur_flag) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '16980')

CHI_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_CHI, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(CHI_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-87.6298, 41.878, 9.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterchicago_insec_medburden.png")



###Make map for Dallas ########
recs2020_burden_DAL  <- recs_2020_merge  %>%  mutate(recs_bur_flag = 100 *recs_bur_flag) %>% rename(est = recs_bur_flag) %>%
  select(est,tract10,cbsa10) %>% filter(cbsa10 == '19100')

DAL_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_DAL, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(DAL_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-96.92, 32.70, 9.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greaterdallas_insec_medburden.png")




###Make map for SFO ########
recs2020_burden_SFO  <- recs_2020_merge %>% mutate(recs_bur_flag = 100 *recs_bur_flag) %>% 
                        select(recs_bur_flag,tract10,cbsa10) %>% filter(cbsa10 == '41860')

SFO_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_burden_SFO, by = c('tract10')) 

map1 <- tm_shape(SFO_burden) + 
  tm_fill(style = "kmeans",col = "recs_bur_flag", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1


map2 <- map1 + tm_view(set.view = c(-122.4194, 37.774, 9.75))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/greatersanfran_insec_medburden.png")



###Only NYC tract-level maps#######
###Load geoconconrdance file########

geo <- fst::read_fst("geo-processed/concordance/geo_concordance.fst", 
                     columns = c("state",'state_postal','tract10','county10')) %>% unique() %>%
                     filter(state_postal == 'NY'& (county10 %in% c('005','047','061','081','085'))) %>% 
                     mutate(tract10 = paste0(state,county10,tract10)) %>% 
                     mutate(tract10 = as.character(tract10)) %>%
                     unique()


# Read food results from disk
recs2020_tract <- readRDS("production/UrbanPop/RECS_2020_tract10_national.rds") %>% 
  select(.,c('lhs','rhs','tract10','est','level')) %>% 
  mutate(tract10 = as.character(tract10)) %>%
  filter(lhs == 'burden' | lhs == 'insec') %>% 
  merge(.,geo, by = 'tract10') 

###Make map for NYC########
recs2020_burden_nat  <- recs2020_tract %>% filter(lhs == 'burden') %>% mutate(est = 100 *est) %>%
                        select(est,tract10) 
recs2020_burden_NY <- recs2020_burden_nat 

nyc_burden <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
    merge(recs2020_burden_NY, by = c('tract10')) %>% rename(burden = est)

map1 <- tm_shape(nyc_burden) + 
  tm_fill(style = "kmeans",col = "burden", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1

map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.75))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/nyc_burden.pdf")



###Make map for NYC########
recs2020_insec_nat  <- recs2020_tract %>% filter(level == 'TRUE') %>% mutate(est = 100 *est) %>%
  select(est,tract10) 
recs2020_insec_NY <- recs2020_insec_nat 

nyc_insec <- tracts(cb = TRUE, year = 2019)  %>%
  rename(county10 = COUNTYFP,
         tract = TRACTCE,
         state = STATEFP) %>% 
  mutate(
    tract10 = paste0(state,county10,tract)) %>% 
  merge(recs2020_insec_NY, by = c('tract10')) %>% rename(insec = est)

map1 <- tm_shape(nyc_insec) + 
  tm_fill(style = "kmeans",col = "insec", palette =  "-RdYlBu",
          alpha = 0.6,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 
map1

map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.75))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "/Users/karthikakkiraju/Documents/fusionData/production/UrbanPop/nyc_insec.pdf")

