module Portal
  module Api
    class Policy < Base
      dotcom_api Portal::Api::Actions::Policies

      def self.get_policies(person_id:)
        DotcomAPI::GetAll
          .request(person_id:)
          .map { |policy| Portal::Policy.new(policy.data) }
      end

      def self.get_policy(policy_number:)
        policy = DotcomAPI::Get
          .request(policy_number:)

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
