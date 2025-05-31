require_relative "boot"

require "rails/all"

require 'dotenv/load' 

Bundler.require(*Rails.groups)

module WPA
  class Application < Rails::Application
    config.load_defaults 7.2

    config.autoload_lib(ignore: %w[assets tasks])
    config.assets.paths << Rails.root.join("app/assets/tailwind")
    config.assets.paths << Rails.root.join("app/assets/images")

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
  end
end
