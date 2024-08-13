module Portal
  # The HomeController handles the logic for the home page of the portal.
  class HomeController < PortalController
    helper Portal::PolicyAccordionHelper

    # The index action for the home page.
    #
    # @return [void]
    def index
      @page_title = text("views.my_policies.index.heading")
      load_policies
      load_slide_carousel
      load_policy_accordion
      load_resumable_policy
      load_failed_card_transactions
    end

    def close_policy_prep_component
      policy = BrightPolicy.find(params[:bright_policy_id])
      policy.record_activity(:policy_prep_component_closed, whodunnit: current_person.id)

      redirect_to "/portal"
    end

    private

    # Loads the policies for the current person.
    #
    # @return [Array<BrightPolicy>] Signed and bound or in-force policies, sorted by effective date + cancelled policies sorted by effective date.
    def load_policies
      @policies ||= (signed_policies | bound_or_in_force_policies).sort_by(&:effective_date) +
        cancelled_policies.sort_by(&:effective_date)
    end

    # Retrieves the signed policies for the current person.
    #
    # @return [ActiveRecord::Relation<BrightPolicy>] The signed policies.
    def signed_policies
      current_person.bright_policies.quote.applied_for(current_person).with_signed_application
    end

    # Retrieves the bound or in-force policies for the current person.
    #
    # @return [ActiveRecord::Relation<BrightPolicy>] The bound or in-force policies.
    def bound_or_in_force_policies
      current_person.bright_policies.bound_or_in_force
    end

    # Retrieves the cancelled policies for the current person.
    #
    # @return [ActiveRecord::Relation<BrightPolicy>] The cancelled policies.
    def cancelled_policies
      current_person.bright_policies.cancelled
    end

    # Loads and sets the slide carousel if it should be shown.
    #
    # @return [void]
    def load_slide_carousel
      return if !should_show_slides?

      create_user_interaction

      @slides = get_customer_portal_slides
      @required_documents_for_slide = get_customer_portal_required_documents_for_slide
    end

    # Loads and sets the policy accordion if there are policies available.
    #
    # @return [void]
    def load_policy_accordion
      return if @policies.blank?

      @steps = PolicyAccordion::StepSerializer.new(@policies).to_a
    end

    # Checks if the slide carousel should be shown.
    #
    # @return [Boolean] `true` if customer has not visited the portal and has a policy, `false` otherwise.
    def should_show_slides?
      !current_user.has_visited_customer_portal? && most_recent_policy.present?
    end

    # Loads and sets the resumable policy for the current person.
    #
    # @return [void]
    def load_resumable_policy
      @resumable_policy = current_person.bright_policies.find do |policy|
        policy.quote? && policy.customer_input_response.present? && policy.created_at >= 2.weeks.ago && !policy&.active_application&.signed_at
      end
    end

    # Loads and sets the failed card transactions for the policies.
    #
    # @return [void]
    def load_failed_card_transactions
      @failed_card_transactions = @policies
        .select(&:payment_type_card?)
        .each_with_object([]) do |policy, failures|
        policy.billing_transactions.status_rejected.each do |transaction|
          failures << transaction if transaction.updated_at > (policy.credit_card&.updated_at || policy.effective_date)
        end
      end
    end

    # Creates a user interaction record for the current user.
    #
    # @return [void]
    def create_user_interaction
      current_user.user_interactions.create(page_visited: "customer_portal")
    end

    # Retrieves the most recent policy from the loaded policies.
    #
    # @return [BrightPolicy, nil] The most recent policy, or `nil` if no policies are loaded.
    def most_recent_policy
      return if @policies.empty?

      @policies.sort_by(&:created_at).reverse[0]
    end

    # Retrieves the customer portal slides for the most recent policy.
    #
    # @return [JSON] The customer portal slides.
    def get_customer_portal_slides
      SlideCarousel::SlideBuilder.build_carousel_slides(most_recent_policy)
    end

    # Retrieves the required documents for the customer portal slide.
    #
    # @return [Array<Document>] The required documents.
    def get_customer_portal_required_documents_for_slide
      SlideCarousel::SlideBuilder.get_required_documents_for_slide(most_recent_policy)
    end
  end
end
