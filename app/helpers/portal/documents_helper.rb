module Portal
  module DocumentsHelper
    def document_upload_url
      Funnel::PermalinkService.url(funnel: Funnel::Flows::DocumentUpload, policy: @policy, user: @user)
    end
  end
end
