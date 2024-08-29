module Portal
  module Api
    class Document
      def self.get_document(id:)
        document = Portal::Api::DocumentSerializer.get_document(id:)

        Portal::Document.new(document.data)
      end
    end
  end
end
