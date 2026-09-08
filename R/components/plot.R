# Component: Interactive Distribution Plot Layout
hypergeometric_plot <- function() {
  tagList(
    h4("Probability Mass Function Visualization"),
    plotOutput("dist_plot"),
    p(
      style = "color: gray; font-size: 0.9em;",
      "Highlighted bars represent the probability of getting 'x or more' successes."
    )
  )
}
