module Portal
  module Api
    class BillingTransaction
      def self.get_transaction(id:)
        transaction = Portal::Api::BillingTransactionSerializer.get_transaction(id:)

        Portal::BillingTransaction.new(transaction.data)
      end

      def self.patch!(id:, changes: {})
        transaction = Portal::Api::BillingTransactionSerializer.patch!(id:, changes:)

        Portal::BillingTransaction.new(transaction.data)
      end

      def self.process_payment!(type:, transaction_id:, policy_number:, user:, opaque_values: {})
        Portal::Api::BillingTransactionSerializer
          .process_payment!(type:, transaction_id:, policy_number:, user:, opaque_values:)
      end

      def self.failed_card_transactions_for_person(person_id:)
        Portal::Api::BillingTransactionSerializer
          .get_failed_card_transactions_for_person(person_id:)
          .map { |transaction| Portal::BillingTransaction.new(transaction.data) }
      end
    end
  end
end
