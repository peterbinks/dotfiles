module Portal
  module Api
    class BillingTransaction
      def self.failed_card_transactions_for_person(person_id:)
        Portal::Api::BillingTransactionSerializer
          .get_failed_card_transactions_for_person(person_id:)
          .map { |transaction| new(transaction.data) }
      end
    end
  end
end
