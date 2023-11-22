####################################################
############   Supporting function to download files
####################################################
#Note 10/11/2023 THis doesnt seem to work propoerly.  
#The ats files are .xlsx, and the unzip command is running,
#even though unzip is invoked under a subsetting if ext =zip

###############################################################

## downloads a file if not present locally and extracts the contents if it is a
## compressed archive

## inputs:
##   url: url where the remote file resides
##   file_name: name of the remote file
##   dir: local directory to save the file [defulat is "."]
##   check_file: optional name of local file, where if present the download will
##              not occur. useful if the remote file is a compressed archive and
##               it shouldn't be downloaded if its contents is already present
##   tolower: covnert file names in a zip file to lower case [default is FALSE]
# 
download_file = function(url,file_name,dir=".",check_file=NA,tolower=F) {
  
  library(httr)
  
  # create the directory if needed
  if (!dir.exists(dir))
    dir.create(dir)
  
  # if no check file name is provided use the remote file name
  if (is.na(check_file))
    check_file = file_name
  
  # if the check file is present then do nothing further
  if (file.exists(file.path(dir,check_file)))
    return()
  
  # download the file
  cat(paste0("downloading ",file_name,"... \n"))
  GET(paste0(url,file_name),
      write_disk(file.path(dir,file_name),overwrite=TRUE),
      progress())
  
  # if the file is a zip archive extract the contents and delete the archive
 # if (tools::file_ext(file_name)=="zip") {
 #   cat("extracting zip file...\n")
 #   unzip(file.path(dir,file_name),exdir=dir)
 #   if (tolower) {
 #     files = unzip(file.path(dir,file_name),list=T)
 #     for (file in files)
 #       file.rename(file.path(dir,file),file.path(dir,tolower(file)))
    }
 #   file.remove(file.path(dir,file_name))
  }
  
  cat("\n")
  #   
}


####################################################
############   AirToxScreen cancer and respiratory risk data
####################################################

# directory to store the ats data
ats_dir = "data\\ats_data"

# 2019(2022) ats file containing national cancer risks by toxic
ats_file = "2019_National_CancerRisk_by_tract_poll.xlsx"
#https://www.epa.gov/system/files/documents/2022-12/2019_National_CancerRisk_by_tract_poll.xlsx
# # download the ats data if it doesn't already exist
download_file("https://www.epa.gov/system/files/documents/2022-12/",
               ats_file,
               dir=ats_dir)


# # Respiratory 
ats_file_resp = "2019_National_RespHI_by_tract_poll.xlsx"

#download_file("https://www.epa.gov/system/files/documents/2022-12/",
 #              ats_file_resp,
 #              dir=ats_dir)

# load the ats data
ats_data = read_excel(file.path(ats_dir,ats_file)) %>%
  rename(total_risk='Total Cancer Risk (per million)')

ats_data_resp = read_excel(file.path(ats_dir,ats_file_resp)) %>%
  rename(total_risk_resp='Total Respiratory (hazard quotient)') %>%
  select(Tract, total_risk_resp)

nata_data_resp <- ats_data_resp
nata_data <- ats_data

####################################

# Merge ats Cancer and Respitory data for nata_data


nata_data <- left_join(ats_data, ats_data_resp, by = 'Tract')

# rearrange tibble column

nata_data <- nata_data %>% 
  select(
    1:7,
    ncol(nata_data),
    everything()
         )






