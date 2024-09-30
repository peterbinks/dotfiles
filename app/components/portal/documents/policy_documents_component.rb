module Portal
  module Documents
    # A component that displays the documents for a given policy.
    class PolicyDocumentsComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::IconHelper

      # The current labels for documents.
      LATEST_VERSION_LABELS_PRIMARY = %w[
        notice_of_cancellation
        notice_of_future_cancellation
        notice_of_non_payment_cancellation
        notice_of_non_renewal
        cancellation_request
        proof_for_cancellation
        no_longer_pending_cancellation_action_required
        no_longer_pending_cancellation_issue_resolved
        policy_renewal_packet
        policy_packet
        declaration_page
        notice_of_change_in_policy_terms
        mortgagee_invoice
        notice_of_hurricane_deductible
      ].freeze

      LATEST_VERSION_LABELS_SECONDARY = %w[
        about_you_legal_text
        about_you_consent_screenshot
        alarm_certificate
        ansi_compliance
        appraisal
        binder
        bookroll_quote
        claims_mediation_letter
        competitor_declaration_page
        corporate_named_insured_questionnaire
        coverage_c_rejection_form
        customer_cancellation_form
        discounts
        dog_cgc
        dog_exclusion
        dog_fence
        earthquake_offer
        eft_page
        electronic_delivery_consent
        electronic_funds_transfer
        elevation_certificate
        flood_policy
        fortified_roof
        good_faith_renewal_letter
        homeowners_bill_of_rights
        inspection_exterior
        inspection_four_point
        inspection_high_value
        inspection_wildfire
        invoice
        limited_agency_agreement
        loss_history_report
        louisiana_hurricane_loss_mitigation_survey_form
        mortgagee_invoice_for_customer
        near_map_image
        notice_of_adverse_action
        notice_of_policy_change
        notice_of_reinstatement
        notice_of_renewal
        ofac_upload_requirement
        other
        photos
        policy_application
        policy_checklist
        policy_document
        privacy_notice
        proof_of_alarm_sprinkler
        proof_of_ansi_compliance
        proof_of_burglar_alarm
        proof_of_duplicate_coverage
        proof_of_fire_protective_devices
        proof_of_fortified_id
        proof_of_inspection
        proof_of_management_company
        proof_of_new_purchase
        proof_of_opening_protection
        proof_of_prior_insurance
        proof_of_repairs
        proof_of_sale
        proof_of_secured_community
        proof_of_water_detection
        protection_period_extension_declarations_rider
        quote
        quote_document
        recurring_payment_notice
        renewal_escrow_payment_reminder
        renewal_insured_payment_reminder
        replacement_cost_estimate
        return_mail
        roof_contract
        roof_permit
        self_inspection
        signature_coverage_collection
        signing_consent_screenshot
        signing_legal_text
        third_party_inspection
        unsigned_policy_application
        unsigned_subscriber_agreement
        wind_coverage_rejection_form
        windstorm_coverage_mortgagee_acknowledgement
        windstorm_coverage_rejection_form
        windstorm_mitigation_form
      ]

      # Third comes before second because second is derivative
      LATEST_VERSION_LABELS_TERTIARY = %w[
        subscriber_agreement
        surplus_lines_acknowledgement_form
        receipt
        statement_of_no_loss
        responsible_repair
      ]

      # LATEST_VERSION_LABELS_SECONDARY = Portal::Document.labels.keys - LATEST_VERSION_LABELS_PRIMARY - LATEST_VERSION_LABELS_TERTIARY

      # @return [BrightPolicy] the policy associated with the documents.
      attr_reader :policy

      # Initializes a new instance of the PolicyDocumentsComponent class.
      #
      # @param policy [BrightPolicy]
      def initialize(policy:)
        @policy = policy
      end

      # Checks if there are no documents associated with this policy.
      #
      # @return [Boolean]
      def empty?
        policy.documents.none?
      end

      # Retrieves documents for the current term.
      #
      # @return [Array<Document>]
      def current_documents
        @current_documents ||=
          primary_documents |
          secondary_documents |
          tertiary_documents
      end

      # Retrieves documents for previous terms.
      #
      # @return [Array<Document>]
      def outdated_documents
        @outdated_documents ||= (policy.documents - current_documents)
          .reject(&:notice_of_hurricane_deductible?)
      end

      private

      # Groups all documents by their label.
      #
      # @return [Hash{String => Array<Document>}]
      def all_documents_grouped
        @all_documents_grouped ||= policy.documents.group_by(&:label)
      end

      # Retrieves the primary documents based on the latest version labels.
      #
      # @return [Array<Document>]
      def primary_documents
        @primary_documents ||= all_documents_grouped
          .select { |k, v| LATEST_VERSION_LABELS_PRIMARY.include?(k) }
          .values
          .flatten
          .reject { |doc| doc.label == "policy_packet" && policy.current_term > 0 }
          .uniq(&:label)
      end

      # Retrieves the secondary documents based on the document labels.
      #
      # @return [Array<Document>]
      def secondary_documents
        @secondary_documents ||= all_documents_grouped
          .select { |k, v| LATEST_VERSION_LABELS_SECONDARY.include?(k) }
          .values
          .flatten
          .uniq(&:label)
      end

      # Retrieves the tertiary documents.
      #
      # @return [Array<Document>]
      def tertiary_documents
        subscriber_agreement +
          surplus_lines_acknowledgement_form +
          receipt +
          statement_of_no_loss +
          responsible_repair
      end

      # Retrieves the subscriber agreement documents.
      #
      # @return [Array<Document>]
      def subscriber_agreement
        @subscriber_agreement ||=
          all_documents_grouped.fetch("subscriber_agreement", [])
      end

      # Retrieves the surplus lines acknowledgement form documents.
      #
      # @return [Array<Document>]
      def surplus_lines_acknowledgement_form
        @surplus_lines_acknowledgement_form ||=
          all_documents_grouped.fetch("surplus_lines_acknowledgement_form", [])
      end

      # Retrieves the receipt documents for the current term.
      #
      # @return [Array<Document>]
      def receipt
        @receipt ||= all_documents_grouped
          .fetch("receipt", [])
          .select { |doc| doc.term >= policy.current_term }
      end

      # Retrieves the statement of no loss documents.
      #
      # @return [Array<Document>]
      def statement_of_no_loss
        @statement_of_no_loss ||= all_documents_grouped
          .fetch("statement_of_no_loss", [])
          .uniq(&:person)
      end

      # Retrieves the responsible repair documents.
      #
      # @return [Array<Document>]
      def responsible_repair
        @responsible_repair ||= all_documents_grouped
          .fetch("responsible_repair", [])
          .uniq(&:person)
      end
    end
  end
end
