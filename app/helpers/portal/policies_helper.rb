module Portal
  module PoliciesHelper
    # Formats the review status based on the given status and effective date.
    #
    # @param status [String] The review status.
    # @param effective_date [Date, nil] The effective date (optional).
    # @return [String] The formatted review status.
    def formatted_review_status(status, effective_date: nil)
      translation = "views.portal.required_documents.review_status.#{status}"
      I18n.translate(translation, effective_date: effective_date, default: status.titleize)
    end

    # Checks if all the documents are pending review.
    #
    # @param documents [Array<Document>] The list of documents.
    # @return [Boolean] `true` if all documents are pending review, `false` otherwise.
    def documents_all_pending_review?(documents)
      documents.present? &&
        documents.filter(&:needs_verification).map(&:review_status).include?("not_reviewed")
    end

    # Checks if any required documents are missing for the given policy.
    #
    # @param policy [Policy] The policy.
    # @return [Boolean] `true` if any required documents are missing, `false` otherwise.
    def missing_required_documents?(policy)
      policy.required_documents_labels.present? &&
        (policy.uploaded_but_not_accepted_required_documents.present? ||
          policy.uploaded_required_documents.empty?)
    end

    # Returns the CSS class for the given document type label.
    #
    # @param label [String] The document type label.
    # @return [String] The CSS class for the document type.
    def doc_type_class(label)
      case label
      when "policy_packet" then " policy-packet"
      when "declaration_page" then " declarations"
      when "policy_application" then " application"
      end
    end

    # Returns the ARIA label for the given document type label.
    #
    # @param label [String] The document type label.
    # @return [String] The ARIA label for the document type.
    def doc_type_aria_label(label)
      case label
      when "policy_packet"
        "policy "
      when "declaration_page", "policy_application"
        "declarations "
      end
    end

    # Splits the premium amount into dollars and cents.
    #
    # @param premium_amount [BigDecimal] The premium amount.
    # @return [Array<String>, nil] The split premium amount as an array of dollars and cents, or `nil` if the amount is not a BigDecimal.
    def split_premium(premium_amount)
      return unless premium_amount.is_a?(BigDecimal)

      number_to_currency(premium_amount).split(".")
    end

    def electronic_fund_transfer_link_url(policy)
      if policy.recurring_payment_notice_doc_url.present?
        url_for(policy.recurring_payment_notice_doc_url)
      else
        "#"
      end
    end
  end
end
