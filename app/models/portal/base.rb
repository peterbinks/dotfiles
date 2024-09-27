module Portal
  class Base
    extend Portal::Dev::QueryMethods

    extend Portal::Utils::HasOne
    extend Portal::Utils::HasMany
    extend Portal::Utils::Attributes

    def initialize(data)
      define_attributes(data)
      define_associations(data)
    end

    # This method shows the has_one and has_many associations the instance has
    # @return [Hash] a hash of the has_one and has_many associations
    def self.associations
      {
        has_one: self.HAS_ONE_ASSOCIATIONS,
        has_many: self.HAS_MANY_ASSOCIATIONS
      }
    end

    # This method shows the has_one and has_many associations the instance has
    # @return [Hash] a hash of the has_one and has_many associations
    def associations
      self.class.associations
    end

    # This method shows the attributes the instance has
    # @return [Hash] a hash of the attribute and value pairs
    # @example
    #   policy = Policy.new({id: 1, policy_number: "1234", status: "bound", current_term: "1"})
    #   policy.attributes # => {id: 1, policy_number: "1234", status: "bound", current_term: "1"}
    def attributes
      {}.tap do |hash|
        self.class.ATTRIBUTES.map do |attr|
          hash[attr] = send(attr)
        end
      end.with_indifferent_access
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
