module Portal
  class Base
    extend Portal::Utils::HasOne
    extend Portal::Utils::HasMany
    extend Portal::Utils::Attributes

    def initialize(data)
      define_attributes(data)
      define_associations(data)
    end

    # This method shows the has_one and has_many associations the instance has
    # @return [Hash] a hash of the has_one and has_many associations
    def associations
      {
        has_one: self.class.HAS_ONE_ASSOCIATIONS,
        has_many: self.class.HAS_MANY_ASSOCIATIONS
      }
    end

    # This method shows the attributes the instance has
    # @return [Array] an array of the attributes
    def attributes
      self.class.ATTRIBUTES
    end

    # This method configures the associations for the instance
    def define_associations(data)
      self.class.configure_has_one(self, data)
      self.class.configure_has_many(self, data)
    end

    # This method configures the attributes for the instance
    def define_attributes(data)
      self.class.configure_attributes(self, data)
    end
  end
end
