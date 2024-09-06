module Portal
  class Property < Base
    attribute :id

    def initialize(property)
      return if property.nil?

      super(property)
    end
  end
end
