module Portal
  module Policies
    class PolicySummaryDetailComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::PolicyStatusHelper
      include Portal::ProductsHelper
      include Portal::IconHelper

      attr_reader :policy

      def initialize(policy:)
        @policy = policy
      end

      def renewal_declaration_page
        @renewal_declaration_page ||= declaration_page_document_for(@policy.upcoming_term)
      end

      def declaration_page_document_for(term)
        policy.documents
          .select { |document| document.label == "declaration_page" && document.term == term }
          .max_by(&:updated_at)
      end
    end
  end
end
