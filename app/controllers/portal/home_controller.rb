module Portal
  class HomeController < PortalController
    before_action :load_index_data

    helper Portal::PolicyAccordionHelper

    # GET /portal
    def index
      load_index_data

      @page_title = text("views.my_policies.index.heading")
      load_slide_carousel
      load_policy_accordion
      load_resumable_policy
    end

    private

    def load_index_data
      @__data = OpenStruct.new(
        policies: policies,
        failed_card_transactions: failed_card_transactions
      )
    end

    def policies
      @policies ||= Portal::BrightPolicy.new(current_person).portal_index_page.policies
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
      return if policies.blank?

      @steps = PolicyAccordion::StepSerializer.new(policies).to_a
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
    def failed_card_transactions
      @failed_card_transactions = policies
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
      return if policies.empty?

      policies.sort_by(&:created_at).reverse[0]
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
