# Component: Premium Modern Typographic Pairing with Fixed Colors
minimal_css <- function() {
  tags$head(
    tags$style(HTML(
      "
      /* Import punchy Inter and clean Plus Jakarta Sans */
      @import url('https://googleapis.com');
      
      body {
        font-family: 'Plus Jakarta Sans', -apple-system, sans-serif;
        background-color: #f8fafc;
        color: #0f172a;
        padding: 30px 15px;
      }
      
      /* --- INTER FOR TITLES & HEADERS --- */
      h2, h4, .app-main-title, .card-value {
        font-family: 'Inter', -apple-system, sans-serif !important;
        font-weight: 700 !important;
        letter-spacing: -0.02em !important;
      }
      
      h2 { font-size: 30px !important; margin-bottom: 35px !important; color: #1e293b; }
      h4 { font-size: 18px !important; margin-bottom: 20px !important; color: #1e293b; }
      
      .well {
        background-color: #ffffff !important;
        border: 1px solid #e2e8f0 !important;
        box-shadow: none !important;
        border-radius: 12px !important;
        padding: 24px !important;
      }
      
      /* --- PLUS JAKARTA SANS FOR INPUTS & LABELS --- */
      .form-control, input, select, textarea {
        font-family: 'Plus Jakarta Sans', sans-serif !important;
        font-weight: 500 !important;
        color: #1e293b !important;
        border: 1px solid #cbd5e1 !important;
        box-shadow: none !important;
        border-radius: 8px !important;
        font-size: 14px !important;
        padding: 10px 14px !important;
        height: auto !important;
        background-color: #ffffff !important;
        transition: all 0.2s ease-in-out !important;
      }
      
      .form-control:focus, input:focus {
        border-color: #6366f1 !important;
        box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1) !important;
        outline: none !important;
      }
      
      .control-label, label {
        font-family: 'Plus Jakarta Sans', sans-serif !important;
        font-size: 13px !important;
        font-weight: 600 !important;
        color: #475569 !important;
        margin-bottom: 6px !important;
        letter-spacing: -0.01em !important;
      }
      
      hr {
        border-top: 1px solid #e2e8f0 !important;
        margin: 25px 0 !important;
      }

      /* Mode Switch Layout */
      .mode-switch-wrapper {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        margin: 10px 0 25px 0;
        user-select: none;
      }
      .switch-label { font-family: 'Plus Jakarta Sans', sans-serif !important; font-size: 13px; font-weight: 500; color: #94a3b8; transition: color 0.25s ease; }
      .switch-container { position: relative; display: inline-block; width: 48px; height: 26px; margin: 0 !important; }
      .switch-container input { opacity: 0; width: 0; height: 0; }
      .switch-container::before { content: \"\"; position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: #64748b; transition: background-color 0.25s ease; border-radius: 34px; }
      .switch-container::after { content: \"\"; position: absolute; height: 18px; width: 18px; left: 4px; bottom: 4px; background-color: white; transition: transform 0.25s cubic-bezier(0.4, 0, 0.2, 1); border-radius: 50%; box-shadow: 0 1px 3px rgba(0,0,0,0.15); }
      .switch-container:has(input:checked)::before { background-color: #4f46e5; }
      .switch-container:has(input:checked)::after { transform: translateX(22px); }
      .mode-switch-wrapper:has(input:not(:checked)) .left-label { color: #1e293b; font-weight: 600; }
      .mode-switch-wrapper:has(input:checked) .right-label { color: #4f46e5; font-weight: 600; }

      /* Dynamic Card Input Rows Alignment */
      .card-input-row { display: flex; gap: 8px; align-items: flex-end; margin-bottom: 12px; }
      .card-name-input { flex: 2; }
      .card-qty-input { flex: 1; }
      .card-hits-input { flex: 1; }
      
      /* Button Group Styles */
      .action-btn-group { display: flex; gap: 8px; margin-top: 18px; }
      
      .btn-add-card {
        width: 100%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        background-color: #ffffff !important;
        color: #475569 !important;
        border: 1px solid #cbd5e1 !important;
        font-family: 'Plus Jakarta Sans', sans-serif !important;
        font-weight: 600 !important;
        font-size: 14px !important;
        padding: 10px 16px !important;
        border-radius: 8px !important;
        transition: all 0.2s ease !important;
        cursor: pointer;
      }
      .btn-add-card:hover { background-color: #f8fafc !important; border-color: #94a3b8 !important; color: #1e293b !important; }
      
      .btn-remove-card {
        background-color: transparent !important;
        color: #94a3b8 !important;
        border: none !important;
        padding: 0 !important;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 50% !important;
        width: 38px;
        height: 38px;
        transition: all 0.15s ease !important;
        cursor: pointer;
      }
      .btn-remove-card:hover { background-color: #fee2e2 !important; color: #ef4444 !important; }

      /* Hide Default Step Arrows */
      input::-webkit-outer-spin-button, input::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; }
      input[type=number] { -moz-appearance: textfield; }

      /* --- DASHBOARD METRIC CARDS --- */
      .result-card-container { display: flex; gap: 16px; margin-bottom: 25px; flex-wrap: wrap; }
      .result-card { flex: 1; min-width: 180px; padding: 20px; border-radius: 14px; text-align: center; box-shadow: 0 1px 3px rgba(0,0,0,0.02); }
      
      .card-label { 
        font-family: 'Plus Jakarta Sans', sans-serif !important;
        font-size: 11px; 
        text-transform: uppercase; 
        letter-spacing: 0.05em; 
        font-weight: 600; 
        margin-bottom: 8px; 
        display: block; 
      }
      
      .card-value { 
        font-size: 36px; 
        letter-spacing: -0.03em; 
        display: block; 
      }
      
      /* FIXED: Re-enforcing specific theme colors for fonts inside the blocks */
      .card-exact { background-color: #fef08a !important; color: #713f12 !important; }
      .card-exact * { color: #713f12 !important; } /* Forces numbers inside to be Dark Amber */

      .card-less { background-color: #e2e8f0 !important; color: #334155 !important; }
      .card-less * { color: #334155 !important; }   /* Forces numbers inside to be Dark Slate */

      .card-greater { background-color: #e0e7ff !important; color: #3730a3 !important; }
      .card-greater * { color: #3730a3 !important; } /* Forces numbers inside to be Dark Indigo */
      
      .shiny-text-output { background: transparent !important; border: none !important; padding: 0 !important; margin: 0 !important; display: inline !important; }
      .formula-box { font-family: 'Plus Jakarta Sans', sans-serif !important; font-size: 13px; color: #64748b; margin-top: 15px; }

      /* Master Execution Button */
      .btn-run {
        width: 100%;
        background-color: #4f46e5 !important;
        color: #ffffff !important;
        font-family: 'Plus Jakarta Sans', sans-serif !important;
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

         /* --- PREMIUM MINIMALIST BRAND LOGO TOGGLES --- */
      .preset-container {
        margin-bottom: 24px;
      }
      .preset-label {
        font-family: 'Plus Jakarta Sans', sans-serif !important;
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        font-weight: 700;
        color: #64748b;
        margin-bottom: 12px;
        display: block;
      }
      .preset-btn-group {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        align-items: center;
      }
      
      /* Turn the heavy boxed buttons into flat, elegant floating targets */
      .btn-preset {
        background-color: transparent !important; /* Strips out the box background */
        border: none !important;                  /* Strips out the box border outline */
        padding: 4px 8px !important;              /* Tightens padding spacing layout */
        border-radius: 6px !important;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        height: auto !important;
        width: auto !important; /* Lets each logo occupy its natural fluid width scale */
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1) !important;
        box-shadow: none !important;
      }
      
      /* Subtle micro-animations for floating interaction feedback */
      .btn-preset:hover {
        background-color: rgba(226, 232, 240, 0.4) !important; /* Smooth transparent background pill hover */
        transform: translateY(-2px);
      }
      
      .btn-preset:active {
        transform: translateY(0px) scale(0.95);
      }
      
      /* --- ENLARGED IMAGE PROPERTIES --- */
      .btn-preset img {
        height: 32px !important;    /* Upscaled from 24px for premium high-visibility presence */
        width: auto !important;
        object-fit: contain;
        display: block;
        filter: grayscale(15%) opacity(90%); /* Subtle editorial filtering */
        transition: filter 0.2s ease !important;
      }
      
      /* Hover highlights the logo color completely */
      .btn-preset:hover img {
        filter: grayscale(0%) opacity(100%);
      }
    "
    ))
  )
}
