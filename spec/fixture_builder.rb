module FixtureBuilder
  def build(record, associations: [])
    attributes = load_fixture_file(record)

    klass = "Portal::#{record.to_s.camelize}".constantize

  
    # associations = klass.ASSOCIATIONS if associations.include?(:all)

    # associations.each do |association|
    #   attributes[association] = load_fixture_file(association)
    # end

    if associations.include?(:all)
      load_all_associations(klass, attributes)
    else
      associations.each do |association|
        attributes[association] = load_fixture_file(association)
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

  def load_all_associations(klass, attributes)
    klass.HAS_ONE_ASSOCIATIONS.each do |association|
      attributes[association] = load_fixture_file(association)
    end
    klass.HAS_MANY_ASSOCIATIONS.each do |association|
      attributes[association] = [load_fixture_file(association)]
    end
  end
end
