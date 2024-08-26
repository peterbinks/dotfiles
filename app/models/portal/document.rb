module Portal
  class Document
    def self.labels
      # TODO get the API class working

      # ::Api::Document.get_failed_card_transactions(policy_id:)
      Portal::Api::DocumentSerializer.labels
    end
  end
end
