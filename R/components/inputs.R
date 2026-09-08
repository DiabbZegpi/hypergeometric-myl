source("components/js_helpers.R")

hypergeometric_inputs <- function() {
  tagList(
    only_positive_integers_js(),
    withMathJax(),

    tags$div(
      class = "only-pos-int",
      numericInput(
        "N",
        "Total Population Size (N):",
        value = 100,
        min = 1,
        step = 1
      ),
      numericInput(
        "K",
        "Successes in Population (K):",
        value = 20,
        min = 0,
        step = 1
      ),
      numericInput("n", "Sample Size (n):", value = 10, min = 1, step = 1),
      numericInput(
        "k",
        "Successes in Sample (x):",
        value = 3,
        min = 0,
        step = 1
      )
    ),

    # --- NEW PROMINENT RUN BUTTON ---
    actionButton(
      inputId = "run_calc",
      label = "Run Calculation",
      class = "btn-run"
    ),

    hr(),

    tags$div(
      class = "formula-box",
      p(
        style = "font-weight: 500; margin-bottom: 8px;",
        "Probability Mass Function:"
      ),
      p("$$P(X = x) = \\frac{\\binom{K}{x}\\binom{N-K}{n-x}}{\\binom{N}{n}}$$")
    )
  )
}
