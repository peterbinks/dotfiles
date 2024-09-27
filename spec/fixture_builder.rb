module FixtureBuilder
  def build(record, associations: [])
    attributes = load_fixture_file(record)

    klass = "Portal::#{record.to_s.camelize}".constantize

    if associations.include?(:all)
      klass.HAS_ONE_ASSOCIATIONS.each do |association|
        attributes[association] = build(association).attributes
      end
      klass.HAS_MANY_ASSOCIATIONS.each do |association|
        attributes[association] = [build(association).attributes]
      end
    else
      associations.each do |association|
        attributes[association] = build(association).attributes
      end
    end

    klass.new(attributes)
  rescue => e
    raise e
  end

  def load_fixture_file(record)
    yaml = file_fixture("#{record.to_s.pluralize}.yml")
    YAML.load_file(yaml).with_indifferent_access
  rescue => e
    # Handle error if file does not exist
    raise e
  end
end
