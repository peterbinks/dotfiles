module Portal
  module Api
    class Policy
      def self.get_policies(person_id:)
        Portal::Api::BrightPolicySerializer
          .get_policies(person_id:)
          .map { |policy| Portal::Policy.new(policy.data) }
      end

      def self.get_policy(policy_number:)
        policy = Portal::Api::BrightPolicySerializer
          .get_policy(policy_number:)

        Portal::Policy.new(policy.data)
      end

      def self.active_policies(person_id:)
        all_policies = get_policies(person_id:)

        all_policies.select(&:active?).sort_by(&:effective_date) |
          all_policies.select(&:cancelled?).sort_by(&:effective_date)
      end
    end
  end
end
