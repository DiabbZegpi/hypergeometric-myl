source("components/js_helpers.R")

hypergeometric_inputs <- function() {
  tagList(
    only_positive_integers_js(),
    withMathJax(),

    # 1. NEW: Modern Pill Switch Toggle
    tags$div(
      class = "mode-switch-wrapper",
      tags$span(class = "switch-label left-label", "Single Card"),
      tags$label(
        class = "switch-container",
        # We use a standard checkbox but handle its state value in R/JS
        checkboxInput("app_mode_toggle", label = NULL, value = FALSE)
      ),
      tags$span(class = "switch-label right-label", "Combo (Multivariate)")
    ),

    hr(),

    # 2. Shared Global Inputs
    numericInput("N", "Total Deck Size:", value = 49, min = 1, step = 1),
    numericInput("n", "Cards to Draw:", value = 8, min = 1, step = 1),

    # 3. Conditional Interface Wrapper (Updated conditions to read our true/false toggle state)
    conditionalPanel(
      condition = "input.app_mode_toggle == false",
      tags$div(
        class = "only-pos-int",
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
      condition = "input.app_mode_toggle == true",
      # Changed class wrapper to 'multivariate-panel' so JS doesn't lock the whole thing
      tags$div(
        class = "multivariate-panel",
        uiOutput("dynamic_multivariate_ui")
      ),

      div(
        class = "action-btn-group",
        tags$button(
          id = "add_card",
          type = "button",
          class = "btn action-button btn-add-card",
          HTML(
            '
              <svg xmlns="http://w3.org" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <line x1="12" y1="5" x2="12" y2="19"></line>
                <line x1="5" y1="12" x2="19" y2="12"></line>
              </svg>
              Add Card
            '
          )
        )
      )
    ),

    br(),

    # 4. Master Execution Button
    actionButton(
      inputId = "run_calc",
      label = "Calculate Odds",
      class = "btn-run"
    ),

    hr(),

    # Formula Box
    conditionalPanel(
      condition = "input.app_mode_toggle == false",
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
      condition = "input.app_mode_toggle == true",
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
