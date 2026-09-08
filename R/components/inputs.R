# Import our new JS blocker helper
source("components/js_helpers.R")

# Component: User Input Fields restricted at the browser level
hypergeometric_inputs <- function() {
  tagList(
    # Inject the JavaScript filter into the page
    only_positive_integers_js(),

    # Wrap inputs in a div container that activates our JavaScript lock
    tags$div(
      class = "only-pos-int",
      numericInput(
        "N",
        "Total Population Size (N):",
        value = 49,
        min = 1,
        step = 1
      ),
      numericInput(
        "K",
        "Successes in Population (K):",
        value = 15,
        min = 0,
        step = 1
      ),
      numericInput("n", "Sample Size (n):", value = 8, min = 1, step = 1),
      numericInput(
        "k",
        "Successes in Sample (x):",
        value = 1,
        min = 0,
        step = 1
      )
    ),
    hr(),
    p("Formula used: dhyper(x, K, N - K, n)")
  )
}
