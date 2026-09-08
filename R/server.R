library(shiny)

server <- function(input, output, session) {
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
