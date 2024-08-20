module Portal
  module Policies
    class PolicySummaryDetailComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::PolicyStatusHelper
      include Portal::ProductsHelper
      include Portal::IconHelper

      def initialize(data:)
        @policy = data.policy
        @all_documents = data.policy.related_documents.shown_in_portal
      end

      def renewal_declaration_page
        @renewal_declaration_page ||= @all_documents
          .where(label: "declaration_page", term: @policy.upcoming_term)
          .order(updated_at: :desc)
          .first
      end
    end
  end
end
