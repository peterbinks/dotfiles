module Portal
  class Policy
    
    # Get the policies for a person
    #
    # @param person_id [String]
    #
    # @return [Array<Portal::Policy>] the policies for the person
    def self.get_policies(person_id:)
      # TODO get the API class working

      # ::Api::Policy.policies_by_person_id(person_id:).map { |policy_data| new(policy_data) }
      Portal::Api::BrightPolicySerializer.get_policies(person_id:).map { |policy_data| new(policy_data) }
    end

    # Get the policy for a policy_number
    #
    # @param policy_number [String]
    #
    # @return [Portal::Policy] the policy for a given policy_number
    def self.get_policy(policy_number:)
      # policy_data = ::Api::Policy.policy_by_policy_number(policy_number:)
      policy_data = Portal::Api::BrightPolicySerializer.get_policy(policy_number:)

      new(policy_data)
    end

    # Get the active policies for the a person
    #
    # @return [Array<Portal::Policy>] the active policies for a person
    def self.active_policies(person_id:)
      all_policies = get_policies(person_id:)

      all_policies.select(&:active?).sort_by(&:effective_date) |
        all_policies.select(&:cancelled?).sort_by(&:effective_date)
    end

    attr_reader :id
    attr_reader :policy_number
    attr_reader :status
    attr_reader :term
    attr_reader :effective_date
    attr_reader :active_application
    attr_reader :has_signed_application
    attr_reader :primary_insured
    attr_reader :co_applicant
    attr_reader :credit_card
    attr_reader :payment_type
    attr_reader :related_documents
    attr_reader :state
    attr_reader :terms
    attr_reader :property
    attr_reader :coverage
    attr_reader :product
    attr_reader :timezone
    attr_reader :billing_transactions
    attr_reader :address
    attr_reader :pending_cancellation
    attr_reader :term_effective_date
    attr_reader :term_end_date
    attr_reader :premium
    attr_reader :policy_accordion_steps
    attr_reader :was_in_force
    attr_reader :portal_documents
    attr_reader :uploaded_required_documents
    attr_reader :uploaded_but_not_accepted_required_documents
    attr_reader :required_documents_labels
    attr_reader :unique_required_documents
    attr_reader :recurring_payment_notice_doc


    delegate :quote?, :bound?, :in_force?, :cancelled?, to: :policy_status

    def initialize(policy)
      @id = policy.id
      @policy_number = policy.policy_number
      @status = policy.status
      @term = policy.term
      @effective_date = policy.effective_date
      @active_application = policy.active_application
      @has_signed_application = policy.has_signed_application
      @primary_insured = policy.primary_insured
      @co_applicant = policy.co_applicant
      @credit_card = policy.credit_card
      @payment_type = policy.payment_type
      @related_documents = policy.related_documents
      @state = policy.state
      @terms = policy.terms
      @property = policy.property
      @coverage = policy.coverage
      @product = policy.product
      @timezone = policy.timezone
      @billing_transactions = policy.billing_transactions
      @address = policy.address
      @pending_cancellation = policy.pending_cancellation
      @term_effective_date = policy.term_effective_date
      @term_end_date = policy.term_end_date
      @premium = policy.premium
      @policy_accordion_steps = policy.policy_accordion_steps
      @was_in_force = policy.was_in_force
      @portal_documents = policy.portal_documents
      @uploaded_required_documents = policy.uploaded_required_documents
      @uploaded_but_not_accepted_required_documents = policy.uploaded_but_not_accepted_required_documents
      @required_documents_labels = policy.required_documents_labels
      @unique_required_documents = policy.unique_required_documents
      @recurring_payment_notice_doc = policy.recurring_payment_notice_doc
    end

    STATUSES = {
      quote: "quote",
      bound: "bound",
      in_force: "in_force",
      cancelled: "cancelled"
    }.freeze

    def policy_status
      ActiveSupport::StringInquirer.new(status)
    end

    def active?
      quote_and_signed? || bound? || in_force?
    end

    # Retrieves the signed policies for the current person.
    #
    # @return [ActiveRecord::Relation<BrightPolicy>] The signed policies.
    def quote_and_signed?
      quote? && has_signed_application == true
    end

    def billing_corrections_needed?
      ::Billing::Corrector.new(self).corrections_needed?
    end
  end
end
