source("components/js_helpers.R")

hypergeometric_inputs <- function() {
  tagList(
    only_positive_integers_js(),
    withMathJax(),

    tags$div(
      class = "only-pos-int",
      # Updated default value parameters to match your custom settings
      numericInput("N", "Total Deck Size:", value = 49, min = 1, step = 1),
      numericInput("K", "Target Cards in Deck:", value = 15, min = 0, step = 1),
      numericInput("n", "Cards to Draw:", value = 8, min = 1, step = 1),
      numericInput("k", "Desired Hits:", value = 3, min = 0, step = 1)
    ),

    actionButton(
      inputId = "run_calc",
      label = "Calculate Odds",
      class = "btn-run"
    ),

    hr(),

    tags$div(
      class = "formula-box",
      p(
        style = "font-weight: 500; margin-bottom: 8px;",
        "Hypergeometric Probability Formula:"
      ),
      p(
        "$$P(X = x) = \\frac{\\binom{\\text{Targets}}{\\text{Hits}}\\binom{\\text{Deck} - \\text{Targets}}{\\text{Draw} - \\text{Hits}}}{\\binom{\\text{Deck}}{\\text{Draw}}}$$"
      )
    )
  )
}
