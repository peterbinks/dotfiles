module Portal
  module Documents
    # Represents a component that displays the required documents for a policy.
    class RequiredDocumentsComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::DocumentsHelper
      include Portal::IconHelper

      # Initializes a new instance of the RequiredDocumentsComponent.
      #
      # @param policy [Policy] The policy for which to display the required documents.
      # @param user [User] The user associated with the policy.
      def initialize(policy:, user:)
        @policy = policy
        @user = user
      end

      # Determines whether to render the component.
      #
      # @return [Boolean] `true` if there are missing required documents, `false` otherwise.
      def render?
        missing_required_documents?(@policy)
      end

      # Retrieves the unique required documents for the policy.
      #
      # @return [Array<String>] An array of unique required document labels.
      def unique_required_documents
        @policy.uploaded_required_documents.pluck(:label).concat(Document.required_for(@policy, exclude_customer_facing: true)).uniq
      end
    end
  end
end
