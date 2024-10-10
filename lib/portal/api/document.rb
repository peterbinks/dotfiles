module Portal
  module Api
    class Document < Base
      dotcom_api Portal::Api::Actions::Documents

      def self.labels
        DotcomAPI::Documents::GetLabels.request
      end

      def self.get_document(id:)
        document = DotcomAPI::Documents::Get.request(id:)

        Portal::Document.new(document.data)
      end

      def self.get_file_path(id:)
        DotcomAPI::Documents::GetSavedFile.request(id:)
      end
    end
  end
end
