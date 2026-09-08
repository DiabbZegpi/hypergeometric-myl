library(shiny)

server <- function(input, output, session) {
  # 1. Centralized boundary safechecks (Directly on inputs, keeps UI warnings live)
  validate_inputs <- function(N, K, n, k) {
    validate(
      need(N >= 1, "• Total Population Size (N) must be at least 1."),
      need(
        K <= N,
        "• Successes in Population (K) cannot be larger than Population Size (N)."
      ),
      need(
        n <= N,
        "• Sample Size (n) cannot be larger than Population Size (N)."
      ),
      need(
        k <= K,
        "• Sample Successes (x) cannot be larger than Population Successes (K)."
      ),
      need(
        k <= n,
        "• Sample Successes (x) cannot be larger than Sample Size (n)."
      )
    )
  }

  # 2. ISOLATE REACTIVITY
  # This block fires ONLY when the 'Run Calculation' button is clicked.
  # It takes a snapshot of the current input values.
  calculated_data <- eventReactive(
    input$run_calc,
    {
      # Check if inputs exist
      req(input$N, input$K, input$n, input$k)

      # Return values as a clean list blueprint
      list(
        N = input$N,
        K = input$K,
        n = input$n,
        k = input$k
      )
    },
    ignoreNULL = FALSE
  ) # ignoreNULL = FALSE ensures it runs once automatically at startup

  # 3. Text Outputs reading strictly from the frozen snapshot data
  output$prob_exact <- renderText({
    data <- calculated_data()
    validate_inputs(data$N, data$K, data$n, data$k)

    prob <- dhyper(data$k, data$K, data$N - data$K, data$n)
    paste0(round(prob * 100, 1), "%")
  })

  output$prob_less <- renderText({
    data <- calculated_data()
    validate_inputs(data$N, data$K, data$n, data$k)

    prob <- phyper(data$k, data$K, data$N - data$K, data$n)
    paste0(round(prob * 100, 1), "%")
  })

  output$prob_greater <- renderText({
    data <- calculated_data()
    validate_inputs(data$N, data$K, data$n, data$k)

    prob <- phyper(
      data$k - 1,
      data$K,
      data$N - data$K,
      data$n,
      lower.tail = FALSE
    )
    paste0(round(prob * 100, 1), "%")
  })

  # 4. Interactive Bar Plot Logic using frozen snapshot data
  output$dist_plot <- renderPlot({
    data <- calculated_data()
    validate_inputs(data$N, data$K, data$n, data$k)

    max_x <- min(data$n, data$K)
    x_vals <- 0:max_x

    probs_raw <- dhyper(x_vals, data$K, data$N - data$K, data$n)
    probs_pct <- probs_raw * 100

    bar_colors <- rep("#e2e8f0", length(x_vals))
    bar_colors[x_vals > data$k] <- "#4f46e5"
    bar_colors[x_vals == data$k] <- "#fcd34d"

    par(mar = c(5, 5, 2, 2), family = "sans")

    bp <- barplot(
      probs_pct,
      names.arg = x_vals,
      col = bar_colors,
      border = NA,
      main = NA,
      xlab = "Number of Successes in Sample (x)",
      ylab = "Probability (%)",
      ylim = c(0, max(probs_pct) * 1.15),
      yaxt = "n",
      las = 1,
      col.lab = "#475569",
      col.axis = "#475569",
      cex.axis = 0.9,
      cex.lab = 1
    )

    y_ticks <- axTicks(2)
    axis(
      2,
      at = y_ticks,
      labels = paste0(y_ticks, "%"),
      las = 1,
      col = NA,
      col.ticks = "#cbd5e1"
    )

    label_colors <- rep("#64748b", length(x_vals))
    label_colors[x_vals > data$k] <- "#4f46e5"
    label_colors[x_vals == data$k] <- "#b45309"

    text(
      x = bp,
      y = probs_pct,
      label = paste0(round(probs_raw * 100, 1), "%"),
      pos = 3,
      cex = 0.85,
      col = label_colors,
      font = 2
    )
  })
}
