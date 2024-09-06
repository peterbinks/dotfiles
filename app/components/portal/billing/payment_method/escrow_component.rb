module Portal
  module Billing
    module PaymentMethod
      class EscrowComponent < Portal::ViewComponent::Base
        attr_reader :policy

        def initialize(policy:)
          @policy = policy
        end

        def render?
          policy.payment_type == "escrow"
        end
      end
    end
  end
end
