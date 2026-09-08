library(shiny)

# Import the specific layout components
source("components/inputs.R")
source("components/outputs.R")

ui <- fluidPage(
  titlePanel("Hypergeometric Probability Calculator"),

  sidebarLayout(
    sidebarPanel(
      hypergeometric_inputs() # Calling our input component
    ),

    mainPanel(
      hypergeometric_outputs() # Calling our output component
    )
  )
)
