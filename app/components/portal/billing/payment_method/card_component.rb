module Portal
  module Billing
    module PaymentMethod
      class CardComponent < Portal::ViewComponent::Base
        attr_reader :policy, :credit_card, :policy_number

        def initialize(policy:)
          @policy = policy
          @credit_card = policy.credit_card
          @policy_number = policy.policy_number
        end

        def render?
          policy.credit_card.present? && policy.payment_type == "card"
        end

        def expiration_month
          credit_card.exp_month.to_s.rjust(2, "0")
        end

        def expiration_year
          credit_card.exp_year
        end

        def last_four_digits
          credit_card.last_4.delete("X")
        end
      end
    end
  end
end
