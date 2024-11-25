#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

source('shiny_app/packages.R')
source('shiny_app/ui.R')
source('shiny_app/server.R')
source('shiny_app/server_test.R')

# Run the application 
shinyApp(ui = ui, server = server_test)
