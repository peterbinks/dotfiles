module Portal
  class Address < Base
    attribute :id
    attribute :full_street_address
    attribute :full_city_state

    def initialize(address)
      return if address.nil?

      super(address)
    end

    def to_s
      full_street_address
    end
  end
end
