module Portal
  class Property < Base
    attribute :id

    def initialize(property)
      return if property.nil?

      super
    end
  end
end
