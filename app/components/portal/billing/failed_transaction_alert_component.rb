module Portal
  module Billing
    class FailedTransactionAlertComponent < Portal::ViewComponent::Base
      def initialize(policy:, transaction:)
        @policy = policy
        @transaction = transaction
        @credit_card = @policy&.credit_card
      end

      def render?
        @policy.credit_card.present?
      end

      def amount
        number_to_currency(@transaction.amount_cents / BigDecimal(100))
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
