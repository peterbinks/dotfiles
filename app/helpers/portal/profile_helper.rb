module Portal
  module ProfileHelper
    def get_full_city_state_name(person)
      person.address.full_city_state.strip.gsub(/[,\s]/, "").empty?
    end

    def ordered_phones(person)
      person.phones.order(primary: :desc, created_at: :desc)
    end
  end
end
