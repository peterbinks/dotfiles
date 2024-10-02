module Portal
  class Engine < ::Rails::Engine
    isolate_namespace Portal

    config.i18n.load_path += Dir["#{Portal::Engine.root.to_s}/config/locales/**/*.{rb,yml}"]
    config.autoload_paths << Portal::Engine.root.join("lib")
    config.autoload_paths << Portal::Engine.root.join("services")
    # config.eager_load_paths << Portal::Engine.root.join("lib")
    # config.eager_load_paths << Portal::Engine.root.join("lib", "api")

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end
  end
end
