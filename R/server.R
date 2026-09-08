library(shiny)

server <- function(input, output, session) {
  # --- MULTIVARIATE DYNAMIC TRACKER ---
  # Keeps track of card rows, their names, quantities, and target hit thresholds
  card_rows <- reactiveValues(ids = c(1, 2)) # Starts with 2 default cards
  row_counter <- reactiveVal(2) # Tracks incremental IDs to prevent naming overlap

  # Trigger: Add Row Button Clicked
  observeEvent(input$add_card, {
    new_id <- row_counter() + 1
    row_counter(new_id)
    card_rows$ids <- c(card_rows$ids, new_id)
  })

  # Trigger: Remove Row Button Clicked
  # We check which specific trash button index was tapped and prune it out
  observeEvent(input$remove_card, {
    target_id <- as.numeric(input$remove_card)
    # Ensure players keep at least 1 card item in multivariate mode
    if (length(card_rows$ids) > 1) {
      card_rows$ids <- card_rows$ids[card_rows$ids != target_id]
    }
  })

  # Render UI Workspace: Generates the rows side-by-side inside the sidebar
  output$dynamic_multivariate_ui <- renderUI({
    ids <- card_rows$ids

    ui_rows <- lapply(ids, function(id) {
      div(
        class = "card-input-row only-pos-int",
        div(
          class = "card-name-input",
          textInput(
            paste0("card_name_", id),
            label = if (id == ids[1]) "Card Name" else NULL,
            value = paste0("Card ", id)
          )
        ),
        div(
          class = "card-qty-input",
          # UPDATED: Changed starting default value from 4 to 3
          numericInput(
            paste0("card_qty_", id),
            label = if (id == ids[1]) "In Deck" else NULL,
            value = 3,
            min = 0,
            step = 1
          )
        ),
        div(
          class = "card-hits-input",
          # UPDATED: Kept starting default value at 1 as requested
          numericInput(
            paste0("card_hits_", id),
            label = if (id == ids[1]) "Min Hits" else NULL,
            value = 1,
            min = 0,
            step = 1
          )
        ),
        tags$button(
          class = "btn-remove",
          type = "button",
          onclick = sprintf(
            "Shiny.setInputValue('remove_card', '%d', {priority: 'event'})",
            id
          ),
          "✕"
        )
      )
    })
    do.call(tagList, ui_rows)
  })

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
      req(input$N, input$n, input$app_mode)

      if (input$app_mode == "single") {
        req(input$K, input$k)
        return(list(
          mode = "single",
          N = input$N,
          n = input$n,
          K = input$K,
          k = input$k
        ))
      } else {
        # Multivariate Mode: Scrape dynamic rows safely
        ids <- card_rows$ids

        # Extract values from input dynamically using their unique IDs
        card_names <- sapply(ids, function(id) {
          input[[paste0("card_name_", id)]]
        })
        card_qtys <- suppressWarnings(sapply(ids, function(id) {
          as.integer(input[[paste0("card_qty_", id)]])
        }))
        card_hits <- suppressWarnings(sapply(ids, function(id) {
          as.integer(input[[paste0("card_hits_", id)]])
        }))

        # Handle blank or loading states gracefully
        if (any(is.na(card_qtys)) || any(is.na(card_hits))) {
          return(NULL)
        }

        return(list(
          mode = "multi",
          N = input$N,
          n = input$n,
          names = card_names,
          qtys = card_qtys,
          hits = card_hits
        ))
      }
    },
    ignoreNULL = FALSE
  )

  # --- MULTIVARIATE MATH ENGINE ---
  compute_multivariate <- function(N, n, qtys, hits, type = "exact") {
    total_assigned_cards <- sum(qtys)
    remainder_cards <- N - total_assigned_cards

    # Validation boundary check
    if (remainder_cards < 0) {
      return(NA)
    }
    if (sum(hits) > n) {
      return(0)
    }

    # Helper to calculate exact probability for a specific combination vector
    calc_exact_vector <- function(current_hits) {
      current_drawn <- sum(current_hits)
      remainder_drawn <- n - current_drawn
      if (remainder_drawn < 0 || remainder_drawn > remainder_cards) {
        return(0)
      }

      # Probability numerator: choose(K1, k1) * choose(K2, k2) * ... * choose(RemainderCards, RemainderDrawn)
      numerator <- prod(choose(qtys, current_hits)) *
        choose(remainder_cards, remainder_drawn)
      denominator <- choose(N, n)

      return(numerator / denominator)
    }

    if (type == "exact") {
      if (any(hits > qtys)) {
        return(0)
      }
      return(calc_exact_vector(hits))
    } else {
      # "At Least" Mode: Expand grid of all possible successful draws
      # Generates a sequence of possible hits for each card row
      ranges <- lapply(1:length(qtys), function(i) hits[i]:min(qtys[i], n))
      grid <- expand.grid(ranges)

      # Sum up exact probabilities of all valid combo vectors
      prob_total <- sum(apply(grid, 1, calc_exact_vector))
      return(min(1, prob_total)) # Cap safely at 100% due to float rounding
    }
  }

  # 3. Clean Dashboard Value Outputs (Dual Mode Supported)
  output$prob_exact <- renderText({
    data <- calculated_data()
    req(data)

    if (data$mode == "single") {
      validate(
        need(data$N >= 1, "• Deck Size error"),
        need(data$K <= data$N, "• Target error"),
        need(data$n <= data$N, "• Draw error"),
        need(data$k <= data$K, "• Hits error"),
        need(data$k <= data$n, "• Hits error")
      )
      prob <- dhyper(data$k, data$K, data$N - data$K, data$n)
      paste0(round(prob * 100, 1), "%")
    } else {
      validate(need(
        sum(data$qtys) <= data$N,
        paste0(
          "• Combined card counts (",
          sum(data$qtys),
          ") exceed total deck size (",
          data$N,
          ")."
        )
      ))
      prob <- compute_multivariate(
        data$N,
        data$n,
        data$qtys,
        data$hits,
        "exact"
      )
      if (is.na(prob)) {
        return("0.0%")
      }
      paste0(round(prob * 100, 1), "%")
    }
  })

  output$prob_less <- renderText({
    data <- calculated_data()
    req(data)

    if (data$mode == "single") {
      prob <- phyper(data$k, data$K, data$N - data$K, data$n)
      paste0(round(prob * 100, 1), "%")
    } else {
      # "Fewer" in multivariate typically means failing your absolute minimum requirements
      validate(need(sum(data$qtys) <= data$N, "• Invalid deck parameters"))
      prob <- 1 -
        compute_multivariate(data$N, data$n, data$qtys, data$hits, "at_least")
      if (is.na(prob)) {
        return("0.0%")
      }
      paste0(round(prob * 100, 1), "%")
    }
  })

  output$prob_greater <- renderText({
    data <- calculated_data()
    req(data)

    if (data$mode == "single") {
      prob <- phyper(
        data$k - 1,
        data$K,
        data$N - data$K,
        data$n,
        lower.tail = FALSE
      )
      paste0(round(prob * 100, 1), "%")
    } else {
      # The core combo metric: Meeting "AT LEAST" all requirements together
      validate(need(sum(data$qtys) <= data$N, "• Invalid deck parameters"))
      prob <- compute_multivariate(
        data$N,
        data$n,
        data$qtys,
        data$hits,
        "at_least"
      )
      if (is.na(prob)) {
        return("0.0%")
      }
      paste0(round(prob * 100, 1), "%")
    }
  })

  # Dynamic Card Labels (Context Swapping)
  output$label_exact <- renderUI({
    data <- calculated_data()
    req(data)
    label_text <- if (data$mode == "single") {
      paste0("Exactly ", data$k, " Hits")
    } else {
      "Exactly All Targets"
    }
    span(class = "card-label", label_text)
  })

  output$label_less <- renderUI({
    data <- calculated_data()
    req(data)
    label_text <- if (data$mode == "single") {
      paste0(data$k, " or Fewer Hits")
    } else {
      "Missed Combo Goals"
    }
    span(class = "card-label", label_text)
  })

  output$label_greater <- renderUI({
    data <- calculated_data()
    req(data)
    label_text <- if (data$mode == "single") {
      paste0(data$k, " or More Hits")
    } else {
      "Full Combo Success"
    }
    span(class = "card-label", label_text)
  })

  # 4. Interactive Bar Plot Logic (With Updated Gaming Axis Titles)
  output$dist_plot <- renderPlot({
    data <- calculated_data()
    req(data)
    validate_inputs(data$N, data$K, data$n, data$k)

    # If multivariate mode is running, pause plot drawing
    if (data$mode == "multi") {
      plot.new()
      text(
        0.5,
        0.5,
        "Distribution plotting is optimized for Single Card Mode.\nReview your combo matrices in the KPI dashboard blocks above.",
        cex = 1.1,
        col = "#64748b",
        font = 5
      )
      return()
    }

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
