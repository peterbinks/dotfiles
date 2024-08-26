module Portal
  module Billing
    # A component that displays a billing corrections alert for a policy.
    class BillingCorrectionsAlertComponent < Portal::ViewComponent::Base
      attr_reader :policy

      # @param policy [BrightPolicy] the policy to display an alert for.
      def initialize(policy:)
        @policy = policy
      end

      # @return [Boolean]
      def render?
        billing_corrections_needed?
      end

      # @return [Boolean]
      def billing_corrections_needed?
        policy.billing_corrections_needed?
      end
    end
  end
end
