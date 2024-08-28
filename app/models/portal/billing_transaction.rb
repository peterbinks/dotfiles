module Portal
  class BillingTransaction < Base
    def self.failed_card_transactions_for_person(person_id:)
      # TODO get the API class working

      # ::Api::BillingTransaction.get_failed_card_transactions(person_id:)
      Portal::Api::BillingTransactionSerializer.get_failed_card_transactions_for_person(person_id:).map { |transaction| new(transaction.data) }
    end

    def self.failed_card_transactions_for_policy(policy_id:)
      # TODO get the API class working

      # ::Api::BillingTransaction.get_failed_card_transactions(policy_id:)
      Portal::Api::BillingTransactionSerializer.get_failed_card_transactions_for_policy(policy_id:).map { |transaction| new(transaction.data) }
    end

    has_one :policy

    attribute :id
    attribute :status_approved
    attribute :endorsement_request_id
    attribute :renewal_endorsement_request_id
    attribute :description
    attribute :installment_number
    attribute :payment_type
    attribute :term_installment_count
    attribute :term_reinstatement_count
    attribute :amount
    attribute :due_date
    attribute :status
    attribute :approved_at
    attribute :document

    def status_approved?
      @status_approved
    end

    def scheduled?
      @scheduled
    end

    def draft?
      @draft
    end

    def write_off?
      @write_off
    end
  end
end
