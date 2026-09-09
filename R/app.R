library(shiny)

# --- NEW: Create a local web directory mapping ---
# This maps your active 'R/' folder to a virtual web path called 'assets'
# It makes images accessible locally AND keeps them fully compatible with Shinylive!
shiny::addResourcePath(prefix = "assets", directoryPath = ".")

source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)
