require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "portal"

if Rails.env.development? || Rails.env.test?
  Dotenv::Railtie.load
end

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f

    config.i18n.load_path += Dir["#{Portal::Engine.root}/config/locales/**/*.{rb,yml}"]

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
