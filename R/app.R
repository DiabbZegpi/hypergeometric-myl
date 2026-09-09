library(shiny)

# (The addResourcePath bridge has been removed since 'www' works natively everywhere!)
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)
