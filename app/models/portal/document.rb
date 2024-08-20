module Portal
  class Document
    def self.labels
      Portal::Serializers::DocumentSerializer.labels
    end

    attr_reader :policy

    def initialize(policy)
      @policy = policy
    end

    # :documents_for_policy_show_page
    # :uploaded_required_documents
    # :uploaded_but_not_accepted_required_documents
    # :required_documents_labels
    # :unique_required_documents
    def policy_show_page
      @policy_show_page ||= Portal::Serializers::DocumentSerializer.new(policy).policy_show_page
    end
  end
end
