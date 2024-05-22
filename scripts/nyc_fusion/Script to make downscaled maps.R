library(fusionModel)
library(fusionData)
library(tigris)
library(mapview)
library(tmap)
library(sf)


# Read food results from disk
food1 <- readRDS("data/nyc_fusion/NYC_food_insecurity/36005_food_insecurity.RDS") %>% select(.,c('TRACT','estimate'))
food2 <- readRDS("data/nyc_fusion/NYC_food_insecurity/36047_food_insecurity.RDS") %>% select(.,c('TRACT','estimate'))
food3 <- readRDS("data/nyc_fusion/NYC_food_insecurity/36061_food_insecurity.RDS") %>% select(.,c('TRACT','estimate'))
food4 <- readRDS("data/nyc_fusion/NYC_food_insecurity/36081_food_insecurity.RDS") %>% select(.,c('TRACT','estimate'))
food5 <- readRDS("data/nyc_fusion/NYC_food_insecurity/36085_food_insecurity.RDS") %>% select(.,c('TRACT','estimate'))

food <- rbind(food1,food2,food3,food4,food5) %>% mutate(estimate = 100*estimate)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(food) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_food.png")

# Read gst results from disk
gst1 <- readRDS("data/nyc_fusion/NHTS_gstotcst_NYC/36005_gstotcst.RDS") %>% select(.,c('TRACT','estimate'))
gst2 <- readRDS("data/nyc_fusion/NHTS_gstotcst_NYC/36047_gstotcst.RDS") %>% select(.,c('TRACT','estimate'))
gst3 <- readRDS("data/nyc_fusion/NHTS_gstotcst_NYC/36061_gstotcst.RDS") %>% select(.,c('TRACT','estimate'))
gst4 <- readRDS("data/nyc_fusion/NHTS_gstotcst_NYC/36081_gstotcst.RDS") %>% select(.,c('TRACT','estimate'))
gst5 <- readRDS("data/nyc_fusion/NHTS_gstotcst_NYC/36085_gstotcst.RDS") %>% select(.,c('TRACT','estimate'))

gst <- rbind(gst1,gst2,gst3,gst4,gst5)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(gst) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_gst.pdf")


# Read vmt results from disk
vmt1 <- readRDS("data/nyc_fusion/NHTS_vmt_mile_NYC/36005_vmt_mile.RDS") %>% select(.,c('TRACT','estimate'))
vmt2 <- readRDS("data/nyc_fusion/NHTS_vmt_mile_NYC/36047_vmt_mile.RDS") %>% select(.,c('TRACT','estimate'))
vmt3 <- readRDS("data/nyc_fusion/NHTS_vmt_mile_NYC/36061_vmt_mile.RDS") %>% select(.,c('TRACT','estimate'))
vmt4 <- readRDS("data/nyc_fusion/NHTS_vmt_mile_NYC/36081_vmt_mile.RDS") %>% select(.,c('TRACT','estimate'))
vmt5 <- readRDS("data/nyc_fusion/NHTS_vmt_mile_NYC/36085_vmt_mile.RDS") %>% select(.,c('TRACT','estimate'))

vmt <- rbind(vmt1,vmt2,vmt3,vmt4,vmt5)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(vmt) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_vmt.pdf")



# Read price results from disk
price1 <- readRDS("data/nyc_fusion/NHTS_tract/36005_price_binary.RDS") %>% select(.,c('TRACT','estimate'))
price2 <- readRDS("data/nyc_fusion/NHTS_tract/36047_price_binary.RDS") %>% select(.,c('TRACT','estimate'))
price3 <- readRDS("data/nyc_fusion/NHTS_tract/36061_price_binary.RDS") %>% select(.,c('TRACT','estimate'))
price4 <- readRDS("data/nyc_fusion/NHTS_tract/36081_price_binary.RDS") %>% select(.,c('TRACT','estimate'))
price5 <- readRDS("data/nyc_fusion/NHTS_tract/36085_price_binary.RDS") %>% select(.,c('TRACT','estimate'))

price <- rbind(price1,price2,price3,price4,price5) %>% mutate(estimate = 100*estimate)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(price) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_price.pdf")

# Read place results from disk
place1 <- readRDS("data/nyc_fusion/NHTS_tract/36005_place_binary.RDS") %>% select(.,c('TRACT','estimate'))
place2 <- readRDS("data/nyc_fusion/NHTS_tract/36047_place_binary.RDS") %>% select(.,c('TRACT','estimate'))
place3 <- readRDS("data/nyc_fusion/NHTS_tract/36061_place_binary.RDS") %>% select(.,c('TRACT','estimate'))
place4 <- readRDS("data/nyc_fusion/NHTS_tract/36081_place_binary.RDS") %>% select(.,c('TRACT','estimate'))
place5 <- readRDS("data/nyc_fusion/NHTS_tract/36085_place_binary.RDS") %>% select(.,c('TRACT','estimate'))

place <- rbind(place1,place2,place3,place4,place5) %>% mutate(estimate = 100*estimate)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(place) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_place.pdf")




# Read ptrans results from disk
ptrans1 <- readRDS("data/nyc_fusion/NHTS_tract/36005_ptrans_binary.RDS") %>% select(.,c('TRACT','estimate'))
ptrans2 <- readRDS("data/nyc_fusion/NHTS_tract/36047_ptrans_binary.RDS") %>% select(.,c('TRACT','estimate'))
ptrans3 <- readRDS("data/nyc_fusion/NHTS_tract/36061_ptrans_binary.RDS") %>% select(.,c('TRACT','estimate'))
ptrans4 <- readRDS("data/nyc_fusion/NHTS_tract/36081_ptrans_binary.RDS") %>% select(.,c('TRACT','estimate'))
ptrans5 <- readRDS("data/nyc_fusion/NHTS_tract/36085_ptrans_binary.RDS") %>% select(.,c('TRACT','estimate'))

ptrans <- rbind(ptrans1,ptrans2,ptrans3,ptrans4,ptrans5) %>% mutate(estimate = 100*estimate)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(ptrans) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_ptrans.pdf")




# Read b burden results from disk
burden1 <- readRDS("data/nyc_fusion/NHTS_burden_NYC/36005_burden.RDS") %>% select(.,c('TRACT','estimate'))
burden2 <- readRDS("data/nyc_fusion/NHTS_burden_NYC/36047_burden.RDS") %>% select(.,c('TRACT','estimate'))
burden3 <- readRDS("data/nyc_fusion/NHTS_burden_NYC/36061_burden.RDS") %>% select(.,c('TRACT','estimate'))
burden4 <- readRDS("data/nyc_fusion/NHTS_burden_NYC/36081_burden.RDS") %>% select(.,c('TRACT','estimate'))
burden5 <- readRDS("data/nyc_fusion/NHTS_burden_NYC/36085_burden.RDS") %>% select(.,c('TRACT','estimate'))

burden <- rbind(burden1,burden2,burden3,burden4,burden5) 

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(burden) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_transbur.pdf")


# Read commute time from disk
JWMNP1 <- readRDS("data/nyc_fusion/ACS_JWMNP_NYC/36005_JWMNP.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP2 <- readRDS("data/nyc_fusion/ACS_JWMNP_NYC/36047_JWMNP.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP3 <- readRDS("data/nyc_fusion/ACS_JWMNP_NYC/36061_JWMNP.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP4 <- readRDS("data/nyc_fusion/ACS_JWMNP_NYC/36081_JWMNP.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP5 <- readRDS("data/nyc_fusion/ACS_JWMNP_NYC/36085_JWMNP.RDS") %>% select(.,c('TRACT','estimate'))

JWMNP <- rbind(JWMNP1,JWMNP2,JWMNP3,JWMNP4,JWMNP5) 

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(JWMNP) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_commute.pdf")


#More commute time maps
# Read commute time from disk
JWMNP1_PTRANS <- readRDS("data/nyc_fusion/commute_times_NYC_3/36005_commute_time_PTRANS.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP2_PTRANS <- readRDS("data/nyc_fusion/commute_times_NYC_3/36047_commute_time_PTRANS.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP3_PTRANS <- readRDS("data/nyc_fusion/commute_times_NYC_3/36061_commute_time_PTRANS.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP4_PTRANS <- readRDS("data/nyc_fusion/commute_times_NYC_3/36081_commute_time_PTRANS.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP5_PTRANS <- readRDS("data/nyc_fusion/commute_times_NYC_3/36085_commute_time_PTRANS.RDS") %>% select(.,c('TRACT','estimate'))

JWMNP_PTRANS <- rbind(JWMNP1_PTRANS,JWMNP2_PTRANS,JWMNP3_PTRANS,JWMNP4_PTRANS,JWMNP5_PTRANS) 

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(JWMNP_PTRANS) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_commute_PTRANS.pdf")

# Read commute time from disk
JWMNP1_WALKBIKE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36005_commute_time_WALKBIKE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP2_WALKBIKE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36047_commute_time_WALKBIKE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP3_WALKBIKE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36061_commute_time_WALKBIKE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP4_WALKBIKE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36081_commute_time_WALKBIKE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP5_WALKBIKE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36085_commute_time_WALKBIKE.RDS") %>% select(.,c('TRACT','estimate'))

JWMNP_WALKBIKE <- rbind(JWMNP1_WALKBIKE,JWMNP2_WALKBIKE,JWMNP3_WALKBIKE,JWMNP4_WALKBIKE,JWMNP5_WALKBIKE) 

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(JWMNP_WALKBIKE) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_commute_WALKBIKE.pdf")



# Read commute time from disk
JWMNP1_PRIVATE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36005_commute_time_PRIVATE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP2_PRIVATE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36047_commute_time_PRIVATE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP3_PRIVATE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36061_commute_time_PRIVATE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP4_PRIVATE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36081_commute_time_PRIVATE.RDS") %>% select(.,c('TRACT','estimate'))
JWMNP5_PRIVATE <- readRDS("data/nyc_fusion/commute_times_NYC_3/36085_commute_time_PRIVATE.RDS") %>% select(.,c('TRACT','estimate'))

JWMNP_PRIVATE <- rbind(JWMNP1_PRIVATE,JWMNP2_PRIVATE,JWMNP3_PRIVATE,JWMNP4_PRIVATE,JWMNP5_PRIVATE) 

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(JWMNP_PRIVATE) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=0, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_commute_PRIVATE.pdf")

#Downscaling Cold
# Read food results from disk
cold1 <- readRDS("data/nyc_fusion/AHS_downscaling/36005_cold.RDS") %>% select(.,c('TRACT','estimate'))
cold2 <- readRDS("data/nyc_fusion/AHS_downscaling/36047_cold.RDS") %>% select(.,c('TRACT','estimate'))
cold3 <- readRDS("data/nyc_fusion/AHS_downscaling/36061_cold.RDS") %>% select(.,c('TRACT','estimate'))
cold4 <- readRDS("data/nyc_fusion/AHS_downscaling/36081_cold.RDS") %>% select(.,c('TRACT','estimate'))
cold5 <- readRDS("data/nyc_fusion/AHS_downscaling/36085_cold.RDS") %>% select(.,c('TRACT','estimate'))

cold <- rbind(cold1,cold2,cold3,cold4,cold5) %>% mutate(estimate = 100*estimate)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(cold) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/nyc_cold.pdf")


#Downscaling NHTS double burden
# Read food results from disk
double1 <- readRDS("data/nyc_fusion/NHTS_downscaling/36005_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double2 <- readRDS("data/nyc_fusion/NHTS_downscaling/36047_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double3 <- readRDS("data/nyc_fusion/NHTS_downscaling/36059_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double4 <- readRDS("data/nyc_fusion/NHTS_downscaling/36061_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double5 <- readRDS("data/nyc_fusion/NHTS_downscaling/36079_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double6 <- readRDS("data/nyc_fusion/NHTS_downscaling/36081_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double7 <- readRDS("data/nyc_fusion/NHTS_downscaling/36085_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double8 <- readRDS("data/nyc_fusion/NHTS_downscaling/36087_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double9 <- readRDS("data/nyc_fusion/NHTS_downscaling/36103_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double10 <- readRDS("data/nyc_fusion/NHTS_downscaling/36119_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double11 <- readRDS("data/nyc_fusion/NHTS_downscaling/36005_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double12<- readRDS("data/nyc_fusion/NHTS_downscaling/36047_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double13 <- readRDS("data/nyc_fusion/NHTS_downscaling/36061_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double14 <- readRDS("data/nyc_fusion/NHTS_downscaling/36081_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double15 <-readRDS("data/nyc_fusion/NHTS_downscaling/36085_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double16 <- readRDS("data/nyc_fusion/NHTS_downscaling/34003_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double17 <- readRDS("data/nyc_fusion/NHTS_downscaling/34013_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double18 <- readRDS("data/nyc_fusion/NHTS_downscaling/34017_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double19 <- readRDS("data/nyc_fusion/NHTS_downscaling/34019_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double20 <- readRDS("data/nyc_fusion/NHTS_downscaling/34023_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double21 <- readRDS("data/nyc_fusion/NHTS_downscaling/34025_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double22 <- readRDS("data/nyc_fusion/NHTS_downscaling/34027_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double23 <- readRDS("data/nyc_fusion/NHTS_downscaling/34029_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double24 <- readRDS("data/nyc_fusion/NHTS_downscaling/34031_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double25 <- readRDS("data/nyc_fusion/NHTS_downscaling/34035_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double26 <- readRDS("data/nyc_fusion/NHTS_downscaling/34037_double_burden.RDS") %>% select(.,c('TRACT','estimate'))
double27 <- readRDS("data/nyc_fusion/NHTS_downscaling/34039_double_burden.RDS") %>% select(.,c('TRACT','estimate'))

double <- rbind(double1,double2,double3,double4,double5,
                double6,double7,double8,double9,double10,
                double11,double12,double13,double14,double15,
                double16,double17,double18,double19,double20,
                double21,double22,double23,double24,double25,
                double26,double27) %>% mutate(estimate = 100*estimate)

# Code for making NYC PUMA maps 
tmap_mode("view")

map1 <- tm_shape(double) + 
  tm_fill(style = "kmeans",col = "estimate", palette =  "-RdYlBu",
          alpha = 0.7,legend.show = TRUE,
          legend.format=list(fun=function(x) paste0(formatC(x, digits=1, format="f")))) + 
  tm_borders(lwd = 0.1) 


map2 <- map1 + tm_view(set.view = c(-74.0060, 40.7128, 10.25))
map2

lf <- tmap_leaflet(map2)
mapshot(lf, file = "output/nyc_fusion/greaternyc_double.pdf")



