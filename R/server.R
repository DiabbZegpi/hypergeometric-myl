library(shiny)

server <- function(input, output, session) {
  # 1. Centralized boundary safechecks
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

  # --- MULTIVARIATE SYSTEM ENGNE (UPDATED FOR PART 3) ---
  card_rows <- reactiveValues(ids = c(1, 2))
  row_counter <- reactiveVal(2)

  # Trigger: Add Row Button Clicked
  observeEvent(input$add_card, {
    new_id <- row_counter() + 1
    row_counter(new_id)
    card_rows$ids <- c(card_rows$ids, new_id)
  })

  # Trigger: Remove Row Button Clicked
  observeEvent(input$remove_card, {
    target_id <- as.numeric(input$remove_card)
    if (length(card_rows$ids) > 1) {
      card_rows$ids <- card_rows$ids[card_rows$ids != target_id]
    }
  })

  # --- DUAL-MODE PRESET OVERWRITE ENGINE ---
  # When a preset is clicked, it updates static fields AND overrides active dynamic row values
  observeEvent(input$btn_myl, {
    updateNumericInput(session, "N", value = 49)
    updateNumericInput(session, "n", value = 8)
    updateNumericInput(session, "K", value = 16)
    updateNumericInput(session, "k", value = 2)
    # Loop over current rows to inject Mitos y Leyendas combo parameters
    for (id in card_rows$ids) {
      updateNumericInput(session, paste0("card_qty_", id), value = 3)
      updateNumericInput(session, paste0("card_hits_", id), value = 1)
    }
  })

  observeEvent(input$btn_mtg, {
    updateNumericInput(session, "N", value = 99)
    updateNumericInput(session, "n", value = 7)
    updateNumericInput(session, "K", value = 40)
    updateNumericInput(session, "k", value = 3)
    # Loop over current rows to inject Magic competitive parameters (4 copies of crucial cards)
    for (id in card_rows$ids) {
      updateNumericInput(session, paste0("card_qty_", id), value = 4)
      updateNumericInput(session, paste0("card_hits_", id), value = 1)
    }
  })

  observeEvent(input$btn_poke, {
    updateNumericInput(session, "N", value = 60)
    updateNumericInput(session, "n", value = 7)
    updateNumericInput(session, "K", value = 4)
    updateNumericInput(session, "k", value = 1)
    # Loop over current rows to inject Pokémon consistency parameters (4-of staples)
    for (id in card_rows$ids) {
      updateNumericInput(session, paste0("card_qty_", id), value = 4)
      updateNumericInput(session, paste0("card_hits_", id), value = 1)
    }
  })

  observeEvent(input$btn_ygo, {
    updateNumericInput(session, "N", value = 40)
    updateNumericInput(session, "n", value = 5)
    updateNumericInput(session, "K", value = 3)
    updateNumericInput(session, "k", value = 1)
    # Loop over current rows to inject Yu-Gi-Oh! parameters (3 copies max per card archetype)
    for (id in card_rows$ids) {
      updateNumericInput(session, paste0("card_qty_", id), value = 3)
      updateNumericInput(session, paste0("card_hits_", id), value = 1)
    }
  })

  # --- ANTI-FOCUS LOSS STATE TRACKER ---
  reactive_row_inputs <- reactive({
    ids <- card_rows$ids
    vals <- lapply(ids, function(id) {
      list(
        name = input[[paste0("card_name_", id)]],
        qty = input[[paste0("card_qty_", id)]],
        hits = input[[paste0("card_hits_", id)]]
      )
    })
    names(vals) <- as.character(ids)
    vals
  })

  debounced_row_inputs <- debounce(reactive_row_inputs, 1000)

  # Render UI Workspace: Seamlessly syncs text entries and lets preset overrides pass through
  output$dynamic_multivariate_ui <- renderUI({
    ids <- card_rows$ids
    saved_states <- debounced_row_inputs()

    ui_rows <- lapply(ids, function(id) {
      str_id <- as.character(id)

      current_name <- if (!is.null(saved_states[[str_id]]$name)) {
        saved_states[[str_id]]$name
      } else {
        paste0("Card ", id)
      }
      current_qty <- if (!is.null(saved_states[[str_id]]$qty)) {
        saved_states[[str_id]]$qty
      } else {
        3
      }
      current_hits <- if (!is.null(saved_states[[str_id]]$hits)) {
        saved_states[[str_id]]$hits
      } else {
        1
      }

      div(
        class = "card-input-row",
        div(
          class = "card-name-input",
          textInput(
            paste0("card_name_", id),
            label = if (id == ids[1]) "Card Name" else NULL,
            value = current_name
          )
        ),
        div(
          class = "card-qty-input",
          numericInput(
            paste0("card_qty_", id),
            label = if (id == ids[1]) "In Deck" else NULL,
            value = current_qty,
            min = 0,
            step = 1
          )
        ),
        div(
          class = "card-hits-input",
          numericInput(
            paste0("card_hits_", id),
            label = if (id == ids[1]) "Min Hits" else NULL,
            value = current_hits,
            min = 0,
            step = 1
          )
        ),

        tags$button(
          class = "btn-remove-card",
          type = "button",
          onclick = sprintf(
            "Shiny.setInputValue('remove_card', '%d', {priority: 'event'})",
            id
          ),
          HTML(
            '
              <svg xmlns="http://w3.org" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
              </svg>
            '
          )
        )
      )
    })

    tagList(ui_rows)
  })

  # --- CORE CALCULATION ENGINES ---
  calculated_data <- eventReactive(
    input$run_calc,
    {
      req(input$N, input$n)
      req(!is.null(input$app_mode_toggle))

      if (input$app_mode_toggle == FALSE) {
        req(input$K, input$k)
        return(list(
          mode = "single",
          N = input$N,
          n = input$n,
          K = input$K,
          k = input$k
        ))
      } else {
        ids <- card_rows$ids
        card_names <- sapply(ids, function(id) {
          input[[paste0("card_name_", id)]]
        })
        card_qtys <- suppressWarnings(sapply(ids, function(id) {
          as.integer(input[[paste0("card_qty_", id)]])
        }))
        card_hits <- suppressWarnings(sapply(ids, function(id) {
          as.integer(input[[paste0("card_hits_", id)]])
        }))

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

  compute_multivariate <- function(N, n, qtys, hits, type = "exact") {
    total_assigned_cards <- sum(qtys)
    remainder_cards <- N - total_assigned_cards
    if (remainder_cards < 0) {
      return(NA)
    }
    if (sum(hits) > n) {
      return(0)
    }

    calc_exact_vector <- function(current_hits) {
      current_drawn <- sum(current_hits)
      remainder_drawn <- n - current_drawn
      if (remainder_drawn < 0 || remainder_drawn > remainder_cards) {
        return(0)
      }
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
      ranges <- lapply(1:length(qtys), function(i) hits[i]:min(qtys[i], n))
      grid <- expand.grid(ranges)
      prob_total <- sum(apply(grid, 1, calc_exact_vector))
      return(min(1, prob_total))
    }
  }

  output$prob_exact <- renderText({
    data <- calculated_data()
    req(data)
    if (data$mode == "single") {
      validate(
        need(data$N >= 1, "• Deck Size error"),
        need(data$K <= data$N, "• Target error"),
        need(data$n <= data$N, "• Draw error"),
        need(data$k <= data$K, "• Hits error")
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

  output$label_exact <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0("Exactly ", data$k, " Hits")
      } else {
        "Exactly All Targets"
      }
    )
  })
  output$label_less <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or Fewer Hits")
      } else {
        "Missed Combo Goals"
      }
    )
  })
  output$label_greater <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or More Hits")
      } else {
        "Full Combo Success"
      }
    )
  })
  output$label_exact <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0("Exactly ", data$k, " Hits")
      } else {
        "Exactly All Targets"
      }
    )
  })
  output$label_less <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or Fewer Hits")
      } else {
        "Missed Combo Goals"
      }
    )
  })
  output$label_greater <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or More Hits")
      } else {
        "Full Combo Success"
      }
    )
  })
  output$label_exact <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0("Exactly ", data$k, " Hits")
      } else {
        "Exactly All Targets"
      }
    )
  })
  output$label_less <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or Fewer Hits")
      } else {
        "Missed Combo Goals"
      }
    )
  })
  output$label_greater <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or More Hits")
      } else {
        "Full Combo Success"
      }
    )
  })
  output$label_exact <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0("Exactly ", data$k, " Hits")
      } else {
        "Exactly All Targets"
      }
    )
  })
  output$label_less <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or Fewer Hits")
      } else {
        "Missed Combo Goals"
      }
    )
  })
  output$label_greater <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or More Hits")
      } else {
        "Full Combo Success"
      }
    )
  })
  output$label_exact <- renderUI({
    data := calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0("Exactly ", data$k, " Hits")
      } else {
        "Exactly All Targets"
      }
    )
  })
  output$label_less <- renderUI({
    data := calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or Fewer Hits")
      } else {
        "Missed Combo Goals"
      }
    )
  })
  output$label_greater <- renderUI({
    data := calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or More Hits")
      } else {
        "Full Combo Success"
      }
    )
  })
  output$label_exact <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0("Exactly ", data$k, " Hits")
      } else {
        "Exactly All Targets"
      }
    )
  })
  output$label_less <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or Fewer Hits")
      } else {
        "Missed Combo Goals"
      }
    )
  })
  output$label_greater <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or More Hits")
      } else {
        "Full Combo Success"
      }
    )
  })
  output$label_exact <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0("Exactly ", data$k, " Hits")
      } else {
        "Exactly All Targets"
      }
    )
  })
  output$label_less <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or Fewer Hits")
      } else {
        "Missed Combo Goals"
      }
    )
  })
  output$label_greater <- renderUI({
    data <- calculated_data()
    req(data)
    span(
      class = "card-label",
      if (data$mode == "single") {
        paste0(data$k, " or More Hits")
      } else {
        "Full Combo Success"
      }
    )
  })
  # 4. Interactive Bar Plot Logic (Clean & Fully Functional)
  output$dist_plot <- renderPlot({
    data <- calculated_data()
    req(data)

    # If multivariate mode is running, pause plot drawing
    if (data$mode == "multi") {
      plot.new()
      text(
        0.5,
        0.5,
        "Distribution plotting is optimized for Single Card Mode.\nReview your combo matrices in the KPI dashboard blocks above.",
        cex = 1.1,
        col = "#64748b",
        font = 2
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
      xlab = "Number of Hits Drawn in Hand (x)",
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

    # Fixed Axis Line Snapping
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
