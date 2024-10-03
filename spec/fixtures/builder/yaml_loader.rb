module Fixtures
  module Builder
    MissingFixtureError = Class.new(StandardError)
    ParseERBError = Class.new(StandardError)
    UnableToLoadFixtureError = Class.new(StandardError)
    MissingTraitError = Class.new(StandardError)

    class YamlLoader
      # @param [Symbol] record the record to load
      # @param [Symbol] a trait that the fixture may have
      # @param [Module] builder the builder object, mainly to access the `file_fixture` method
      def self.call(record, trait, builder)
        new(record, trait, builder).call
      end

      attr_reader :record, :trait, :builder

      def initialize(record, trait, builder)
        @record = record
        @trait = trait
        @builder = builder
      end

      # This method loads a fixture file for a record which includes default attributes
      # @return [Hash] the attributes for the record
      def call
        record
          .then { locate_fixture_file _1 }
          .then { parse_erb _1 }
          .then { load_fixture _1 }
          .then { locate_trait _1 }
      end

      private

      def locate_fixture_file(record)
        builder.file_fixture("#{record.to_s.pluralize}.yml")
      rescue => e
        raise MissingFixtureError, "No fixture file found for `#{record}`"
      end

      def parse_erb(file_name)
        ERB.new(File.read(file_name)).result
      rescue => e
        raise ParseERBError, "Error parsing ERB in `#{file_name}`"
      end

      def load_fixture(parsed_erb)
        YAML.load(parsed_erb)
      rescue => e
        raise UnableToLoadFixtureError, "Unable to load fixture for `#{record}`"
      end

      def locate_trait(loaded_fixture)
        loaded_fixture.with_indifferent_access.fetch(trait.to_s)
      rescue => e
        raise MissingTraitError, "No trait found for `#{trait}` in `#{record.to_s.pluralize}.yml`"
      end
    end
  end
end
