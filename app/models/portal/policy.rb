module Portal
  class Policy < Base
    # API Requests

    def self.get_policies(person_id:)
      # TODO get the API class working

      # ::Api::Policy.policies_by_person_id(person_id:).map { |policy_data| new(policy_data) }
      Portal::Api::BrightPolicySerializer.get_policies(person_id:).map { |policy| new(policy.data) }
    end

    def self.get_policy(policy_number:)
      # policy_data = ::Api::Policy.policy_by_policy_number(policy_number:)
      policy = Portal::Api::BrightPolicySerializer.get_policy(policy_number:)

      new(policy.data)
    end

    def self.active_policies(person_id:)
      all_policies = get_policies(person_id:)

      all_policies.select(&:active?).sort_by(&:effective_date) |
        all_policies.select(&:cancelled?).sort_by(&:effective_date)
    end

    # These need to be the EXACT name of the association fetched from dot-com
    has_one :property
    has_one :coverage
    has_one :product
    has_one :address

    # These need to be the EXACT name of the association fetched from dot-com
    has_many :billing_transactions
    has_many :upcoming_transactions_for_term
    has_many :rejected_transactions_for_term
    has_many :documents
    has_many :applicants

    # These need to be the EXACT name of the attribute fetched from dot-com
    attribute :id
    attribute :policy_number
    attribute :status
    attribute :current_term
    attribute :upcoming_term
    attribute :effective_date
    attribute :active_application
    attribute :has_signed_application
    attribute :credit_card
    attribute :payment_type
    attribute :state
    attribute :timezone
    attribute :pending_cancellation
    attribute :term_effective_date
    attribute :term_end_date
    attribute :premium
    attribute :policy_accordion_steps
    attribute :was_in_force
    attribute :uploaded_required_documents
    attribute :uploaded_but_not_accepted_required_documents
    attribute :required_documents_labels
    attribute :unique_required_documents
    attribute :recurring_payment_notice_doc
    attribute :billing_corrections_needed
    attribute :auth_net_client

    delegate :quote?, :bound?, :in_force?, :cancelled?, to: :policy_status

    def primary_insured
      applicants.find(&:primary)
    end

    def co_applicant
      applicants.find(&:co_applicant)
    end

    def policy_status
      ActiveSupport::StringInquirer.new(status)
    end

    def active?
      quote_and_signed? || bound? || in_force?
    end

    def quote_and_signed?
      quote? && has_signed_application == true
    end

    def billing_corrections_needed?
      billing_corrections_needed
    end
  end
end
