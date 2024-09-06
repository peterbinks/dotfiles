module Portal
  class BillingTransaction < Base
    has_one :receipt

    attribute :id
    attribute :endorsement_request_id
    attribute :renewal_endorsement_request_id
    attribute :description
    attribute :installment_number
    attribute :payment_type
    attribute :term
    attribute :term_installment_count
    attribute :term_reinstatement_count
    attribute :amount
    attribute :amount_cents
    attribute :due_date
    attribute :status
    attribute :approved_at
    attribute :payment_made
    attribute :updated_at

    delegate :scheduled?, to: :billing_payment_type
    delegate :upcoming?, :approved?, :rejected?, to: :billing_status

    def billing_payment_type
      ActiveSupport::StringInquirer.new(payment_type)
    end

    def billing_status
      ActiveSupport::StringInquirer.new(status)
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

    def is_payment?
      %i[refund waved_refund write_off cancellation].exclude?(payment_type)
    end

    def recently_approved?
      approved? &&
        updated_at > 1.minute.ago
    end

    def recently_rejected?
      rejected? &&
        due_date > 15.day.ago
    end
  end
end
