module Portal
  class Document < Base
    def self.labels
      Portal::Api::Document.labels
    end

    has_one :saved_file

    attribute :id
    attribute :label
    attribute :term
    attribute :display_name
    attribute :status
    attribute :signed_at
    attribute :expiring_url
    attribute :updated_at

    def surplus_lines_acknowledgement_form?
      label == "surplus_lines_acknowledgement_form"
    end

    def notice_of_hurricane_deductible?
      label == "notice_of_hurricane_deductible"
    end

    def policy_application?
      label == "policy_application"
    end

    def complete?
      status == "complete"
    end

    def signed?
      signed_at.present?
    end
  end
end
