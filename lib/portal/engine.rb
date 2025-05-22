# frozen_string_literal: true
require 'vite_ruby'

module Portal
  class Engine < ::Rails::Engine
    isolate_namespace Portal
    delegate :vite_ruby, to: :class

    config.i18n.load_path += Dir["#{Portal::Engine.root}/config/locales/**/*.{rb,yml}"]
    config.autoload_paths << Portal::Engine.root.join("lib")
    config.autoload_paths << Portal::Engine.root.join("services")
    # config.eager_load_paths << Portal::Engine.root.join("lib")
    # config.eager_load_paths << Portal::Engine.root.join("lib", "api")

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

     def self.vite_ruby
      @vite_ruby ||= ViteRuby.new(root: root, mode: Rails.env)
    end

    # Expose compiled assets via Rack::Static when running in the host app.
    config.app_middleware.use(Rack::Static,
      urls: ["/#{ vite_ruby.config.public_output_dir }"],
      root: root.join(vite_ruby.config.public_dir))

    initializer 'vite_rails_engine.proxy' do |app|
      if vite_ruby.run_proxy?
        app.middleware.insert_before 0, ViteRuby::DevServerProxy, ssl_verify_none: true, vite_ruby: vite_ruby
      end
    end

    initializer 'vite_rails_engine.logger' do
      config.after_initialize do
        vite_ruby.logger = Rails.logger
      end
    end
  end
end
