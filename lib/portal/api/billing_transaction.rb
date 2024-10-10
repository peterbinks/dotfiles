module Portal
  module Api
    class BillingTransaction < Base
      dotcom_api Portal::Api::Actions::BillingTransactions

      def self.get_transaction(id:)
        transaction = DotcomAPI::Get.request(id:)

        Portal::BillingTransaction.new(transaction.data)
      end

      def self.patch!(id:, changes: {})
        transaction = DotcomAPI::Patch.request(id:, changes:)

        Portal::BillingTransaction.new(transaction.data)
      end

      def self.process_payment!(type:, transaction_id:, policy_number:, user:, opaque_values: {})
        DotcomAPI::ProcessPayment.request(
          type:,
          transaction_id:,
          policy_number:,
          user:,
          opaque_values:
        )
      end

      def self.failed_card_transactions_for_person(person_id:)
        DotcomAPI::GetFailedForPerson
          .request(person_id:)
          .map { |transaction| Portal::BillingTransaction.new(transaction.data) }
      end
    end
  end
end
