library(shiny)

# Define the user interface
ui <- fluidPage(
  titlePanel("Hypergeometric Probability Calculator"),

  sidebarLayout(
    sidebarPanel(
      numericInput("N", "Total Population Size (N):", value = 100, min = 1),
      numericInput("K", "Successes in Population (K):", value = 20, min = 0),
      numericInput("n", "Sample Size (n):", value = 10, min = 1),
      numericInput("k", "Successes in Sample (x):", value = 3, min = 0),
      hr(),
      p("Formula used: dhyper(x, K, N - K, n)")
    ),

    mainPanel(
      h4("Results"),
      verbatimTextOutput("prob_exact"),
      verbatimTextOutput("prob_less"),
      verbatimTextOutput("prob_greater")
    )
  )
)

# Define the calculator logic
server <- function(input, output) {
  output$prob_exact <- renderText({
    prob <- dhyper(input$k, input$K, input$N - input$K, input$n)
    paste0(
      "Probability of EXACTLY ",
      input$k,
      " successes: ",
      round(prob * 100, 4),
      "%"
    )
  })

  output$prob_less <- renderText({
    prob <- phyper(input$k, input$K, input$N - input$K, input$n)
    paste0(
      "Probability of ",
      input$k,
      " OR FEWER successes: ",
      round(prob * 100, 4),
      "%"
    )
  })

  output$prob_greater <- renderText({
    # lower.tail = FALSE calculates P(X > x), so we use x - 1 to get P(X >= x)
    prob <- phyper(
      input$k - 1,
      input$K,
      input$N - input$K,
      input$n,
      lower.tail = FALSE
    )
    paste0(
      "Probability of ",
      input$k,
      " OR MORE successes: ",
      round(prob * 100, 4),
      "%"
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
