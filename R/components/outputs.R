# Component: Display Outputs
hypergeometric_outputs <- function() {
  tagList(
    h4("Results"),
    verbatimTextOutput("prob_exact"),
    verbatimTextOutput("prob_less"),
    verbatimTextOutput("prob_greater")
  )
}
