# Component: Minimalistic CSS Styling with Favicon
minimal_css <- function() {
  tags$head(
    # --- UPDATED: Points exactly to the flat root asset folder ---
    tags$link(rel = "shortcut icon", href = "./logo.png", type = "image/png"),

    tags$style(HTML(
      "
      @import url('https://googleapis.com');
      
      body {
        font-family: 'Inter', -apple-system, sans-serif;
        background-color: #f8fafc;
        color: #0f172a;
        padding: 30px 15px;
      }
      
      h2 {
        font-weight: 600;
        letter-spacing: -0.02em;
        margin-bottom: 30px;
        color: #1e293b;
      }
      
      .well {
        background-color: #ffffff !important;
        border: 1px solid #e2e8f0 !important;
        box-shadow: none !important;
        border-radius: 12px !important;
        padding: 24px !important;
      }
      
      .form-control {
        border: 1px solid #cbd5e1 !important;
        box-shadow: none !important;
        border-radius: 6px !important;
        font-size: 14px !important;
        padding: 8px 12px !important;
        height: auto !important;
      }
      
      .form-control:focus {
        border-color: #6366f1 !important;
      }
      
      hr {
        border-top: 1px solid #e2e8f0 !important;
        margin: 25px 0 !important;
      }

      .result-card-container {
        display: flex;
        gap: 16px;
        margin-bottom: 25px;
        flex-wrap: wrap;
      }

      .result-card {
        flex: 1;
        min-width: 180px;
        padding: 20px;
        border-radius: 14px;
        text-align: center;
        box-shadow: 0 1px 3px rgba(0,0,0,0.02);
      }

      .card-label {
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-weight: 600;
        margin-bottom: 6px;
        display: block;
      }

      .card-value {
        font-size: 32px;
        font-weight: 700;
        letter-spacing: -0.03em;
        display: block;
      }

      .card-exact { background-color: #fef08a !important; color: #713f12 !important; }
      .card-less { background-color: #e2e8f0 !important; color: #334155 !important; }
      .card-greater { background-color: #e0e7ff !important; color: #3730a3 !important; }

      .shiny-text-output {
        font-family: 'Inter', sans-serif !important;
        background: transparent !important;
        border: none !important;
        padding: 0 !important;
        margin: 0 !important;
        display: inline !important;
      }

      .formula-box {
        font-size: 13px;
        color: #64748b;
        margin-top: 15px;
      }

      .btn-run {
        width: 100%;
        background-color: #4f46e5 !important;
        color: #ffffff !important;
        font-family: 'Inter', sans-serif !important;
        font-weight: 600 !important;
        font-size: 15px !important;
        padding: 12px 20px !important;
        border: none !important;
        border-radius: 8px !important;
        margin-top: 15px;
        transition: background-color 0.2s ease-in-out, transform 0.1s ease !important;
        box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.1), 0 2px 4px -1px rgba(79, 70, 229, 0.06) !important;
      }

      .btn-run:hover { background-color: #4338ca !important; }
      .btn-run:active { transform: scale(0.98) !important; }
    "
    ))
  )
}
