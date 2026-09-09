library(shiny)

source("components/inputs.R")
source("components/outputs.R")
source("components/plot.R")
source("components/css_styles.R")

# --- UPDATED: Added the global browser tab title parameter ---
ui <- fluidPage(
  title = "TCG Deck Simulator & Odds Calculator", # <--- Type your exact browser tab title here!

  minimal_css(),

  titlePanel("TCG Probability & Deck Simulator"),

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
