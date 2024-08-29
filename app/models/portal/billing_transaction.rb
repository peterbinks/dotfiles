module Portal
  class BillingTransaction < Base
    has_one :policy

    attribute :id
    attribute :status_approved
    attribute :endorsement_request_id
    attribute :renewal_endorsement_request_id
    attribute :description
    attribute :installment_number
    attribute :payment_type
    attribute :term
    attribute :term_installment_count
    attribute :term_reinstatement_count
    attribute :amount
    attribute :due_date
    attribute :status
    attribute :approved_at
    attribute :payment_made
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

    def upcoming_for_term?
      !payment_made &&
        !%i[refund waved_refund write_off cancellation].include?(payment_type) &&
        status == "upcoming" &&
        term == policy.current_term
    end

    def rejected_for_term?
      status == "rejected" &&
        term == policy.current_term
    end
  end
end
