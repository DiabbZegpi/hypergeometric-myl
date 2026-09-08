hypergeometric_outputs <- function() {
  tagList(
    h4(
      style = "margin-bottom: 20px; font-weight: 600; letter-spacing: -0.01em;",
      "Dashboard Metrics"
    ),

    # We use UI rendering tools to connect our isolated text values
    div(
      class = "result-card-container",
      div(
        class = "result-card card-exact",
        uiOutput("label_exact"),
        span(class = "card-value", textOutput("prob_exact"))
      ),
      div(
        class = "result-card card-less",
        uiOutput("label_less"),
        span(class = "card-value", textOutput("prob_less"))
      ),
      div(
        class = "result-card card-greater",
        uiOutput("label_greater"),
        span(class = "card-value", textOutput("prob_greater"))
      )
    )
  )
}
