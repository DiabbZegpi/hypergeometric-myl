library(shiny)

server <- function(input, output, session) {
  # 1. Centralized boundary safechecks (Translated to TCG terms)
  validate_inputs <- function(N, K, n, k) {
    validate(
      need(N >= 1, "• Deck Size must be at least 1 card."),
      need(
        K <= N,
        "• Target Cards in Deck cannot be larger than your total Deck Size."
      ),
      need(
        n <= N,
        "• Cards to Draw cannot be larger than your total Deck Size."
      ),
      need(
        k <= K,
        "• Desired Hits cannot be larger than the total Target Cards in your deck."
      ),
      need(
        k <= n,
        "• Desired Hits cannot be larger than the number of Cards to Draw."
      )
    )
  }

  # 2. Isolate Reactivity via Run Button
  calculated_data <- eventReactive(
    input$run_calc,
    {
      req(input$N, input$K, input$n, input$k)
      list(
        N = input$N,
        K = input$K,
        n = input$n,
        k = input$k
      )
    },
    ignoreNULL = FALSE
  )

  # 3. Clean Dashboard Value Outputs (Calculations are identical, numbers only)
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

  # Dynamic Card Labels (Using translated gaming context text structures)
  output$label_exact <- renderUI({
    data <- calculated_data()
    span(class = "card-label", paste0("Exactly ", data$k, " Hits"))
  })

  output$label_less <- renderUI({
    data <- calculated_data()
    span(class = "card-label", paste0(data$k, " or Fewer Hits"))
  })

  output$label_greater <- renderUI({
    data <- calculated_data()
    span(class = "card-label", paste0(data$k, " or More Hits"))
  })

  # 4. Interactive Bar Plot Logic (With Updated Gaming Axis Titles)
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
      xlab = "Number of Hits Drawn in Hand (x)", # Gaming axis label
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

    lines(
      x = c(par("usr")[1], par("usr")[1]),
      y = c(0, max(probs_pct) * 1.15),
      col = "#cbd5e1",
      lwd = 2
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
