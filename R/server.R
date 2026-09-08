library(shiny)

server <- function(input, output, session) {
  # Centralized boundary safechecks (for logical limits like K <= N)
  validate_inputs <- reactive({
    req(input$N, input$K, input$n, input$k)

    validate(
      need(input$N >= 1, "• Total Population Size (N) must be at least 1."),
      need(
        input$K <= input$N,
        "• Successes in Population (K) cannot be larger than Population Size (N)."
      ),
      need(
        input$n <= input$N,
        "• Sample Size (n) cannot be larger than Population Size (N)."
      ),
      need(
        input$k <= input$K,
        "• Sample Successes (x) cannot be larger than Population Successes (K)."
      ),
      need(
        input$k <= input$n,
        "• Sample Successes (x) cannot be larger than Sample Size (n)."
      )
    )
  })

  # Main Calculations
  output$prob_exact <- renderText({
    validate_inputs()
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
    validate_inputs()
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
    validate_inputs()
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
