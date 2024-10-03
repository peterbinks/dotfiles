module Portal
  module Policies
    class DisplayPremiumComponent < ViewComponent::Base
      attr_reader :amount, :premium_dollars, :premium_cents

      # Creates DisplayPremiumComponent that is accessibiliy compliant.
      #
      # @param amount [Numeric] the premium amount
      def initialize(amount:)
        raise TypeError, "The amount must be a number. You supplied #{amount.inspect}" unless amount.is_a?(Numeric)

        @amount = amount
        @premium_dollars, @premium_cents = split_premium
      end

      private

      def split_premium
        number_to_currency(amount).split(".")
      end
    end
  end
end
