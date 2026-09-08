library(shiny)

# Import the specific layout components
source("components/inputs.R")
source("components/outputs.R")
source("components/plot.R")
source("components/css_styles.R")

ui <- fluidPage(
  minimal_css(),
  titlePanel("Hypergeometric Probability Calculator"),

  sidebarLayout(
    sidebarPanel(
      hypergeometric_inputs() # Calling our input component
    ),

    mainPanel(
      hypergeometric_outputs(), # Calling our output component
      hr(),
      hypergeometric_plot()
    )
  )
)
