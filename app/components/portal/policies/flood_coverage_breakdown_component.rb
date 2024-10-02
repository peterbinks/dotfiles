module Portal
  module Policies
    class FloodCoverageBreakdownComponent < ViewComponent::Base
      attr_reader :amount, :flood_coverage_amount

      # Creates FloodCoverageBreakdownComponent that is accessibiliy compliant.
      #
      # @param amount [Numeric] the premium amount
      # @param flood_coverage_amount [Numeric] the flood coverage amount
      def initialize(amount:, flood_coverage_amount:)
        @amount = amount
        @flood_coverage_amount = flood_coverage_amount
      end

      private

      def render?
        amount.is_a?(Numeric) && flood_coverage_amount.is_a?(Numeric)
      end
    end
  end
end
