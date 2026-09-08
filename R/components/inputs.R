# Component: User Input Fields
hypergeometric_inputs <- function() {
  tagList(
    numericInput("N", "Total Population Size (N):", value = 100, min = 1),
    numericInput("K", "Successes in Population (K):", value = 20, min = 0),
    numericInput("n", "Sample Size (n):", value = 10, min = 1),
    numericInput("k", "Successes in Sample (x):", value = 3, min = 0),
    hr(),
    p("Formula used: dhyper(x, K, N - K, n)")
  )
}
