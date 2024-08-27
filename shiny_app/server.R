# Define server logic 
server <- function(input, output, session) {
  data <- reactive({
    req(input$file)
    file <- input$file
    ext <- tools::file_ext(file$datapath)
    if (ext == "csv") {
      read_csv(file$datapath)
    } else if (ext == 'xlsx') {
      read_excel(file$datapath)
    } else {
      stop("Please upload csv or xlsx file.")
    }
  })
  
  output$column_select <- renderUI({
    req(data())
    selectInput("column", "Select Unique Identifier Column:", choices = colnames(data()))
  })
  
  observeEvent(input$run_pipeline, {
    #req(input$file)
    #req(input$column)
    #req(input$table_title)
    
    
    
   # tmp_file <- tempfile(fileext = ".rds")
    #saveRDS(data(), tmp_file)
    
    
    
targets_script <- "

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


)"
  
  writeLines(targets_script, "_targets_app.R")
  tar_make(facilities, script = "_targets_app.R")
  
  output$result <- renderTable({
    tar_read(facilities)
  })
  })
}
