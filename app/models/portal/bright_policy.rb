module Portal
  class BrightPolicy
    def self.find(id)
      Portal::Serializers::BrightPolicySerializer.find(id)
    end

    def self.from_policy_number(id)
      Portal::Serializers::BrightPolicySerializer.from_policy_number(id)
    end

    attr_reader :current_person

    def initialize(current_person)
      @current_person = current_person
    end

    # :policies
    def portal_index_page
      @portal_index ||= Portal::Serializers::BrightPolicySerializer.new(current_person).portal_index_page
    end
  end
end
