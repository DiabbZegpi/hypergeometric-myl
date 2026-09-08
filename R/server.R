library(shiny)

server <- function(input, output, session) {
  # Centralized boundary safechecks
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

  # Text Outputs
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

  # Interactive Bar Plot Logic (With Percentage Y-Axis)
  output$dist_plot <- renderPlot({
    validate_inputs()

    # 1. Determine the maximum possible successes in a sample
    max_x <- min(input$n, input$K)
    x_vals <- 0:max_x

    # 2. Calculate probabilities and scale them to full percentages (0 - 100)
    probs_raw <- dhyper(x_vals, input$K, input$N - input$K, input$n)
    probs_pct <- probs_raw * 100

    # 3. Soft, clean modern colors (Indigo Blue and Slate/Muted Blue-Gray)
    # Yaaxis and bars will match beautifully now
    bar_colors <- ifelse(x_vals >= input$k, "#4f46e5", "#cbd5e1")

    # 4. Generate the bar chart using the scaled percentage metrics
    bp <- barplot(
      probs_pct,
      names.arg = x_vals,
      col = bar_colors,
      border = "white",
      main = "Hypergeometric Distribution Probabilities",
      xlab = "Number of Successes in Sample (x)",
      ylab = "Probability (%)", # Explicitly stating it's a percentage axis
      ylim = c(0, max(probs_pct) * 1.15), # Leaves comfortable headroom for text labels
      yaxt = "n", # Turn off default Y-axis labels so we can customize them below
      las = 1
    )

    # 5. Create custom Y-axis markers featuring the "%" character
    y_ticks <- axTicks(2)
    axis(2, at = y_ticks, labels = paste0(y_ticks, "%"), las = 1)

    # 6. Add the individual percentage tags right on top of each bar
    text(
      x = bp,
      y = probs_pct,
      label = paste0(round(probs_raw * 100, 1), "%"),
      pos = 3,
      cex = 0.9,
      col = "#1e293b",
      font = 2 # Bolds the text labels for better readability
    )
  })
}
