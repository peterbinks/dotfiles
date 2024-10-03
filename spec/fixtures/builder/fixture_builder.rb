require_relative "yaml_loader"

module Fixtures
  module Builder
    module FixtureBuilder
      def build(record, trait: :default, **attributes)
        # Loads fixture file (raises error if fixture file doesn't exist)
        default_fixture_attributes = YamlLoader.call(record, trait, self)

        # Sets portal klass
        klass = "Portal::#{record.to_s.camelize}".constantize

        # Initializes class with attributes and associations
        klass.new(default_fixture_attributes.merge(attributes))
      rescue => e
        raise e
      end
    end
  end
end
