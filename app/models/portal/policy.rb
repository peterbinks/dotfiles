module Portal
  class Policy < Base
    # These need to be the EXACT name of the association fetched from dot-com
    has_one :property
    has_one :coverage
    has_one :product
    has_one :address
    has_one :credit_card

    # These need to be the EXACT name of the association fetched from dot-com
    has_many :billing_transactions
    has_many :documents
    has_many :applicants
    has_many :terms
    has_many :policy_accordion_steps

    # These need to be the EXACT name of the attribute fetched from dot-com
    attribute :id
    attribute :policy_number
    attribute :status
    attribute :current_term
    attribute :upcoming_term
    attribute :payment_type
    attribute :state
    attribute :pending_cancellation
    attribute :premium
    attribute :uploaded_required_documents
    attribute :required_documents_labels
    attribute :unique_required_documents
    attribute :recurring_payment_notice_doc_url
    attribute :billing_corrections_needed
    attribute :has_signed_active_application
    attribute :has_in_progress_endorsement
    attribute :auth_net_client

    delegate :quote?, :bound?, :in_force?, :cancelled?, :expired?, :non_renewed?, to: :policy_status

    def primary_insured
      @primary_insured ||= applicants.find(&:primary)
    end

    def co_applicant
      @co_applicant ||= applicants.find(&:co_applicant)
    end

    def policy_status
      ActiveSupport::StringInquirer.new(status)
    end

    def has_signed_active_application?
      has_signed_active_application
    end

    def uploaded_but_not_accepted_required_documents
      documents.select do |doc|
        doc.review_status != "accepted" &&
          (required_documents_labels | "other").include?(doc.label)
      end
    end

    def active?
      quote_and_signed? || bound? || in_force?
    end

    def quote_and_signed?
      quote? && has_signed_active_application?
    end

    def billing_corrections_needed?
      billing_corrections_needed
    end

    def term_groups
      @term_groups ||= terms.map { |term| [term.number, term] }.to_h
    end

    def effective_date
      @effective_date ||= term_groups[0]&.effective_date
    end

    def term_effective_date
      term_groups[current_term]&.effective_date
    end

    def term_end_date
      term_groups[current_term]&.end_date
    end

    def in_quote_post_effective_date?
      effective_date < Date.current && quote?
    end
  end
end
