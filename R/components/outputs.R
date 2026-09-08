hypergeometric_outputs <- function() {
  tagList(
    h4(
      style = "margin-bottom: 20px; font-weight: 600; letter-spacing: -0.01em;",
      "Dashboard Metrics"
    ),

    div(
      class = "result-card-container",
      div(
        class = "result-card card-exact",
        span(class = "card-label", "Exactly x Successes"),
        span(class = "card-value", textOutput("prob_exact"))
      ),
      div(
        class = "result-card card-less",
        span(class = "card-label", "x or Fewer Successes"),
        span(class = "card-value", textOutput("prob_less"))
      ),
      div(
        class = "result-card card-greater",
        span(class = "card-label", "x or More Successes"),
        span(class = "card-value", textOutput("prob_greater"))
      )
    )
  )
}
