library(shiny)

# Point Shinylive to your separated files
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)
