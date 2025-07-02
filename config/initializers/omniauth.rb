
OmniAuth.config.allowed_request_methods = [ :post ]
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV["GOOGLE_CLIENT_ID"],
           ENV["GOOGLE_CLIENT_SECRET"],
           {
            scope: "email,profile",
            prompt: "select_account",
            setup: lambda { |env|
              request = Rack::Request.new(env)
              Rails.logger.info "[DEBUG] redirect_uri: #{request.base_url}/auth/google_oauth2/callback"
            }
             
           }
end
