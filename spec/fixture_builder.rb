module FixtureBuilder
  def build(record, fix_type: :default, **attributes)
    # Loads fixture file (raises error if fixture file doesn't exist)
    default_attributes = load_default_attributes(record, fix_type)

    # Sets portal klass
    klass = "Portal::#{record.to_s.camelize}".constantize

    # Initializes class with attributes and associations
    klass.new(default_attributes.merge(attributes))
  rescue => e
    raise e
  end

  # This method loads a fixture file for a record which includes default attributes
  # @param [Symbol] record the record to load
  # @return [Hash] the attributes for the record
  def load_default_attributes(record, fix_type)
    yaml = file_fixture("#{record.to_s.pluralize}.yml")
    YAML.load_file(yaml).with_indifferent_access[fix_type.to_s]
  rescue => e
    # Handle error if file does not exist
    raise e
  end
end
