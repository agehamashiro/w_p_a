require_relative "boot"

require "rails/all"

require 'dotenv/load' if Rails.env.development? || Rails.env.test?

# Require the gems listed in Gemfile, including any gems
#
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load environment variables from .env file

module WPA
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # Set secret_key_base for production environment using Rails credentials
    #config.secret_key_base = Rails.application.credentials.production[:secret_key_base]


    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.assets.paths << Rails.root.join("app/assets/tailwind")
    config.assets.paths << Rails.root.join("app/assets/images")
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
