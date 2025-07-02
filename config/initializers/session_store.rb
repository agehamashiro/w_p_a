Rails.application.config.session_store :cookie_store,
  key: '_wpa_session',
  secure: true,
  same_site: :none
end