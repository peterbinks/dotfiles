module Portal
  module Policies
    class PolicySummaryComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::PolicyStatusHelper
      include Portal::ProductsHelper
      include Portal::IconHelper

      attr_reader :policy

      def initialize(policy:)
        @policy = policy
      end

      def claims_url(policy_number)
        "#{claims_app_ui_host}?policyNumber=#{policy_number}"
      end

      def claims_app_ui_host
        ENV.fetch("CLAIMS_APP_UI_HOST", "https://claims.kin.com")
      end

      def declaration_page_document
        @declaration_page_document ||= declaration_page_document_for(@policy.current_term)
      end

      def renewal_declaration_page
        @renewal_declaration_page ||= declaration_page_document_for(@policy.upcoming_term)
      end

      def declaration_page_document_for(term)
        policy.documents
          .select { |document| document.label == "declaration_page" && document.term == term }
          .max_by(&:updated_at)
      end

      def download_path(document_id)
        portal_routes.download_policy_document_path(policy_id: @policy.policy_number, id: document_id)
      end

      def document_id(document)
        "document-#{document.label.titleize.parameterize}"
      end
    end
  end
end
