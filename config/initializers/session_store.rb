Rails.application.config.session_store :cookie_store,
  key: '_wpa_session',                
  secure: Rails.env.production?,     
  same_site: :none,                   
  httponly: true    