require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Capybaraを使う場合に必要
require 'capybara/rspec'

# WebMock（Gemini APIなど外部通信のスタブ用）
require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

# Shoulda Matchers (モデルのバリデーションなどを簡潔に記述)
require 'shoulda/matchers'

# ActiveRecordのスキーマを維持
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Fixturesディレクトリ
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # トランザクションごとにテストデータをリセット
  config.use_transactional_fixtures = true

  # FactoryBotの省略形 (`create(:user)` など) を使う
  config.include FactoryBot::Syntax::Methods

  # System spec (Capybara) ドライバ設定
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # backtraceをスッキリさせる
  config.filter_rails_from_backtrace!
end

# Shoulda Matchersの設定
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

