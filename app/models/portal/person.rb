module Portal
  class Person < Base
    source "Person", "Portal::Api::PersonSerializer"

    attribute :id
    attribute :first_name
    attribute :last_name
    attribute :user_id

    def initialize(person)
      return if person.nil?

      super(person)
    end
  end
end
