module Portal
  module Billing
    # A component that displays an alert for a policy that is missing a credit card.
    class NoCreditCardAlertComponent < Portal::ViewComponent::Base
      include Portal::ModalHelper

      def initialize(policy:)
        @policy = policy
      end

      def render?
        !@policy.credit_card && @policy.payment_type == "card"
      end
    end
  end
end
