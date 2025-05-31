# frozen_string_literal: true
require 'omniauth-google-oauth2'

Devise.setup do |config|
  config.mailer_sender = 'please-change-me@example.com'
  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.omniauth_path_prefix = '/users/auth'
  Rails.logger.debug "GOOGLE_CLIENT_ID: #{ENV['GOOGLE_CLIENT_ID'].inspect}"
  Rails.logger.debug "GOOGLE_CLIENT_SECRET: #{ENV['GOOGLE_CLIENT_SECRET'].inspect}"

  config.omniauth :google_oauth2,
                  ENV['GOOGLE_CLIENT_ID'],
                  ENV['GOOGLE_CLIENT_SECRET'],
                  {
                    scope: 'userinfo.email,userinfo.profile',
                    prompt: 'select_account',
                    access_type: 'offline'
                  }
end

