module Portal
  class Base
    def self.BELONGS_TO_ASSOCIATIONS
      @belongs_to_associations ||= []
    end

    def self.HAS_ONE_ASSOCIATIONS
      @has_one_associations ||= []
    end

    def self.HAS_MANY_ASSOCIATIONS
      @has_many_associations ||= []
    end

    def self.belongs_to(association_name)
      self.BELONGS_TO_ASSOCIATIONS << association_name
    end

    def self.has_one(association_name)
      self.HAS_ONE_ASSOCIATIONS << association_name
    end

    def self.has_many(association_name)
      self.HAS_MANY_ASSOCIATIONS << association_name
    end

    def configure_belongs_to
      self.class.BELONGS_TO_ASSOCIATIONS.each do |association_name|
        define_singleton_method(association_name) do
          Portal.const_get(association_name.to_s.classify).new(data[association_name])
        end
      end
    end

    def configure_has_one
      self.class.HAS_ONE_ASSOCIATIONS.each do |association_name|
        define_singleton_method(association_name) do
          Portal.const_get(association_name.to_s.classify).new(data[association_name])
        end
      end
    end

    def configure_has_many
      self.class.HAS_MANY_ASSOCIATIONS.each do |association_name|
        define_singleton_method(association_name) do
          data[association_name].map { |record| Portal.const_get(association_name.to_s.classify).new(record) }
        end
      end
    end

    def self.ATTRIBUTES
      @attributes ||= []
    end

    def self.attribute(attribute_name)
      self.ATTRIBUTES << attribute_name
    end

    def configure_attributes
      self.class.ATTRIBUTES.each do |attribute|
        # Set on initialization
        instance_variable_set("@#{attribute}", data[attribute])

        # Getter
        define_singleton_method(attribute) do
          instance_variable_get("@#{attribute}")
        end

        # Setter
        define_singleton_method("#{attribute}=") do |value|
          instance_variable_set("@#{attribute}", value)
        end
      end
    end

    def define_associations
      configure_belongs_to
      configure_has_one
      configure_has_many
    end

    def initialize(data)
      @data = data

      configure_attributes
      define_associations
    end

    attr_reader :data
  end
end
