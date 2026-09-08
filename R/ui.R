library(shiny)

source("components/inputs.R")
source("components/outputs.R")
source("components/plot.R")
source("components/css_styles.R")

ui <- fluidPage(
  minimal_css(),

  titlePanel("TCG Probability & Deck Simulator"), # Re-themed title text

  sidebarLayout(
    sidebarPanel(
      hypergeometric_inputs()
    ),

    mainPanel(
      hypergeometric_outputs(),
      hr(),
      hypergeometric_plot()
    )
  )
)
