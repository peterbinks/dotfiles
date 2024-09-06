module Portal
  module Api
    class Document
      def self.get_document(id:)
        document = Portal::Api::DocumentSerializer.get_document(id:)

        Portal::Document.new(document.data)
      end

      def self.get_file_path(id:)
        Portal::Api::DocumentSerializer.get_file_path(id:)
      end
    end
  end
end
