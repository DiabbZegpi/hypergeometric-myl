# Component: Frontend JavaScript restrictions
only_positive_integers_js <- function() {
  tags$script(HTML(
    "
    $(document).on('keypress', '.only-pos-int input', function(e) {
      // Allow only numbers 0-9 (ASCII keys 48 to 57)
      if (e.which < 48 || e.which > 57) {
        e.preventDefault();
      }
    });

    $(document).on('paste', '.only-pos-int input', function(e) {
      // Prevent pasting text or decimals
      var pastedData = (e.originalEvent || e).clipboardData.getData('text');
      if (!/^[0-9]+$/.test(pastedData)) {
        e.preventDefault();
      }
    });
  "
  ))
}
