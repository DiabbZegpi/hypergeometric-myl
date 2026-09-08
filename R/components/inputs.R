source("components/js_helpers.R")

hypergeometric_inputs <- function() {
  tagList(
    only_positive_integers_js(),
    withMathJax(),

    # 1. Mode Selector
    div(
      class = "mode-container",
      radioButtons(
        "app_mode",
        "Calculator Mode:",
        choices = c("Single Card" = "single", "Combo (Multivariate)" = "multi"),
        selected = "single"
      )
    ),

    hr(),

    # 2. Shared Global Inputs (Locked with your custom defaults!)
    numericInput("N", "Total Deck Size:", value = 49, min = 1, step = 1),
    numericInput("n", "Cards to Draw:", value = 8, min = 1, step = 1),

    # 3. Conditional Interface Wrapper
    conditionalPanel(
      condition = "input.app_mode == 'single'",
      tags$div(
        class = "only-pos-int",
        # Locked with your custom defaults!
        numericInput(
          "K",
          "Target Cards in Deck:",
          value = 15,
          min = 0,
          step = 1
        ),
        numericInput("k", "Desired Hits:", value = 3, min = 0, step = 1)
      )
    ),

    conditionalPanel(
      condition = "input.app_mode == 'multi'",
      uiOutput("dynamic_multivariate_ui"),

      div(
        class = "action-btn-group",
        actionButton("add_card", "+ Add Card", class = "btn-secondary")
      )
    ),

    br(),

    # 4. Master Isolated Execution Button
    actionButton(
      inputId = "run_calc",
      label = "Calculate Odds",
      class = "btn-run"
    ),

    hr(),

    # Formula Box
    conditionalPanel(
      condition = "input.app_mode == 'single'",
      tags$div(
        class = "formula-box",
        p(
          style = "font-weight: 500; margin-bottom: 8px;",
          "Hypergeometric Formula:"
        ),
        p(
          "$$P(X = x) = \\frac{\\binom{K}{x}\\binom{N-K}{n-x}}{\\binom{N}{n}}$$"
        )
      )
    ),
    conditionalPanel(
      condition = "input.app_mode == 'multi'",
      tags$div(
        class = "formula-box",
        p(
          style = "font-weight: 500; margin-bottom: 8px;",
          "Multivariate Hypergeometric Formula:"
        ),
        p(
          "$$P(X_1=k_1, ..., X_m=k_m) = \\frac{\\binom{K_1}{k_1}\\binom{K_2}{k_2}...\\binom{K_r}{k_r}}{\\binom{N}{n}}$$"
        )
      )
    )
  )
}
