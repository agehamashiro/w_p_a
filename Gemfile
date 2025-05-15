source "https://rubygems.org"

gem "rails", "~> 7.2.2.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

gem 'httparty' # APIリクエスト用
gem 'dotenv-rails', '3.1.0'
gem "tailwindcss-rails"
gem 'devise'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", "~> 7.0.2", require: false
  gem "rubocop-rails-omakase", require: false

  # ✅ Rubocop関連Gemの追加
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false

  # ✅ RSpec本体
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'webdrivers'
  gem 'webmock'

  gem "factory_bot_rails"
  gem "faker"
  gem "database_cleaner-active_record"
end
