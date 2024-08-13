module Portal
  module Billing
    class FailedTransactionAlertComponent < Portal::ViewComponent::Base
      def initialize(transaction:)
        @transaction = transaction
        @policy = transaction.bright_policy
        @credit_card = @policy&.credit_card
      end

      def render?
        @policy.credit_card.present?
      end

      def policy_number
        @policy.full_policy_number
      end

      def amount
        number_to_currency(@transaction.amount_cents / BigDecimal("100"))
      end

      def payment_type
        endorsement_payment? ? "Endorsement" : @transaction.installment_number&.ordinalize
      end

      def last_4
        @policy.credit_card.last_4
      end

      def address
        @policy.address.full_street_address
      end

      def show_update_link?
        request.path.split("/").last != "edit"
      end

      private

      def endorsement_payment?
        @transaction.installment_number.nil? && @transaction.endorsement_request_id.present?
      end
    end
  end
end
