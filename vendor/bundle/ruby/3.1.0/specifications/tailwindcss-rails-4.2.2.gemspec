# -*- encoding: utf-8 -*-
# stub: tailwindcss-rails 4.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "tailwindcss-rails".freeze
  s.version = "4.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 3.2.0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/rails/tailwindcss-rails", "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2025-04-05"
  s.email = "david@loudthinking.com".freeze
  s.homepage = "https://github.com/rails/tailwindcss-rails".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "== Upgrading to Tailwind CSS v4 ==\n\nIf you are upgrading to tailwindcss-rails 4.x, please read the upgrade guide at:\n\n  https://github.com/rails/tailwindcss-rails/blob/main/README.md#upgrading-your-application-from-tailwind-v3-to-v4\n\nIf you're not ready to upgrade yet, please pin to version 3 in your Gemfile:\n\n  gem \"tailwindcss-rails\", \"~> 3.3.1\"\n\n".freeze
  s.rubygems_version = "3.3.26".freeze
  s.summary = "Integrate Tailwind CSS with the asset pipeline in Rails.".freeze

  s.installed_by_version = "3.3.26" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<railties>.freeze, [">= 7.0.0"])
    s.add_runtime_dependency(%q<tailwindcss-ruby>.freeze, ["~> 4.0"])
  else
    s.add_dependency(%q<railties>.freeze, [">= 7.0.0"])
    s.add_dependency(%q<tailwindcss-ruby>.freeze, ["~> 4.0"])
  end
end
