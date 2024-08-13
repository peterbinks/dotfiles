module Portal
  module Billing
    # A component that displays a billing corrections alert for a policy.
    class BillingCorrectionsAlertComponent < Portal::ViewComponent::Base
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
        ::Billing::Corrector.new(@policy).corrections_needed?
      end
    end
  end
end
