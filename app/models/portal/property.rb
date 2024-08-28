module Portal
  class Property < Base
    has_one :policy

    attribute :id

    def initialize(property)
      return if property.nil?

      super(property)
    end
  end
end
