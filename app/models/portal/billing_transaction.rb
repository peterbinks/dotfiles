module Portal
  class BillingTransaction
    def self.failed_card_transactions_for_person(person_id:)
      # TODO get the API class working

      # ::Api::BillingTransaction.get_failed_card_transactions(person_id:)
      Portal::Api::BillingTransactionSerializer.get_failed_card_transactions_for_person(person_id:)
    end

    def self.failed_card_transactions_for_policy(policy_id:)
      # TODO get the API class working

      # ::Api::BillingTransaction.get_failed_card_transactions(policy_id:)
      Portal::Api::BillingTransactionSerializer.get_failed_card_transactions_for_policy(policy_id:)
    end
  end
end
