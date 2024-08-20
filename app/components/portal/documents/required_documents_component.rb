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
      def initialize(data:)
        @policy = data.policy
        @user = data.user
        @document = data.document
      end

      # Determines whether to render the component.
      #
      # @return [Boolean] `true` if there are missing required documents, `false` otherwise.
      def render?
        missing_required_documents?(@document)
      end
    end
  end
end
