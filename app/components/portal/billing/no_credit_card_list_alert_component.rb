module Portal
  module Billing
    # A component that displays an alert for one or more policies that are
    # missing a credit card.
    class NoCreditCardListAlertComponent < Portal::ViewComponent::Base
      # @return [Array<BrightPolicy>]
      attr_reader :policies_missing_credit_cards

      # @param policies [Array<BrightPolicy>] all of a person's policies.
      def initialize(policies:)
        @policies_missing_credit_cards = policies.select do |policy|
          policy.credit_card.blank? && policy.payment_type == "card"
        end
      end

      # @return [Boolean]
      def render?
        policies_missing_credit_cards.any?
      end

      # @return [String]
      def policy_or_policies_word
        singular? ? "policy" : "policies"
      end

      # @return [String]
      def to_policy_or_policies_phrase
        if singular?
          "to this policy to ensure it remains active"
        else
          "to each of these policies to ensure they remain active"
        end
      end

      def full_address(policy)
        "#{policy.address.full_street_address} #{policy.address.full_city_state}"
      end

      private

      # @return [Boolean]
      def singular?
        policies_missing_credit_cards.count == 1
      end
    end
  end
end
