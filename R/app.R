library(shiny)

# FIXED: Uses a valid name 'img' to create a secure local path bridge
shiny::addResourcePath(prefix = "img", directoryPath = ".")

source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)
