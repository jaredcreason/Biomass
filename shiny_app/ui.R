# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("CEB EJ: Proxmity Analysis Tool"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload tabular data for pipeline.",
                accept = c('.csv','.xlsx')),
      uiOutput("column_select"),
      textInput("table_title", "Enter table name:", value = ''),
      actionButton("run_pipeline", "Run Pipeline")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("result")
    )
  )
)
