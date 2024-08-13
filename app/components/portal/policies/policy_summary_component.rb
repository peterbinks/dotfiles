module Portal
  module Policies
    class PolicySummaryComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::PolicyStatusHelper
      include Portal::ProductsHelper
      include Portal::IconHelper

      def initialize(policy:)
        @policy = policy
        @all_documents = @policy.related_documents.shown_in_portal
      end

      def renewal_declaration_page
        @renewal_declaration_page ||= @all_documents
          .where(label: "declaration_page", term: @policy.upcoming_term)
          .order(updated_at: :desc)
          .first
      end

      def claims_url(policy_number)
        "#{claims_app_ui_host}?policyNumber=#{policy_number}"
      end

      def claims_app_ui_host
        EnvWrapper.fetch("CLAIMS_APP_UI_HOST", "https://claims.kin.com")
      end

      def declaration_page_document
        return @declaration_page_document if defined? @declaration_page_document

        @declaration_page_document = @all_documents
          .where(label: "declaration_page")
          .order(updated_at: :desc)
          .first
      end

      def download_path(document_id)
        api_v2_policy_document_download_path(policy_id: @policy.id, document_id: document_id)
      end

      def document_id(document)
        "document-#{document.label.titleize.parameterize}"
      end
    end
  end
end
