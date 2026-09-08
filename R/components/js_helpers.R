# Component: Frontend JavaScript restrictions (Targeted explicitly)
only_positive_integers_js <- function() {
  tags$script(HTML(
    "
    /* Targets only numeric fields inside our specialized containers */
    $(document).on('keypress', '.only-pos-int input, .multivariate-panel input[type=\"number\"]', function(e) {
      if (e.which < 48 || e.which > 57) {
        e.preventDefault();
      }
    });

    $(document).on('paste', '.only-pos-int input, .multivariate-panel input[type=\"number\"]', function(e) {
      var pastedData = (e.originalEvent || e).clipboardData.getData('text');
      if (!/^[0-9]+$/.test(pastedData)) {
        e.preventDefault();
      }
    });
  "
  ))
}
