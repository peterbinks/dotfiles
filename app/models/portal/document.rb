module Portal
  class Document < Base
    def self.labels
      # TODO get the API class working

      # ::Api::Document.get_failed_card_transactions(policy_id:)
      Portal::Api::DocumentSerializer.labels
    end

    has_one :policy

    attribute :id
    attribute :label
    attribute :term
    attribute :display_name
    attribute :status
    attribute :saved_file
    attribute :updated_at

    def surplus_lines_acknowledgement_form?
      label == "surplus_lines_acknowledgement_form"
    end

    def notice_of_hurricane_deductible?
      label == "notice_of_hurricane_deductible"
    end

    def complete?
      status == "complete"
    end
  end
end
