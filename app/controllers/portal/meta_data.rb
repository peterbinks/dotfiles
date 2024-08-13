module Portal
  module MetaData
    extend ActiveSupport::Concern

    included do
      helper_method :canonical_url
    end

    # ----------------------------------------------------------------------------
    # Private: Sets the canonical URL for the requested page.
    #
    # Returns a String.
    # ----------------------------------------------------------------------------

    def canonical_url
      @canonical_url ||= url_for_app(
        controller: params[:controller],
        action: params[:action],
        id: params[:id],
        protocol: request.protocol,
        only_path: false
      )
    end

    private

    def url_for_app(options = {})
      main_app.url_for(options) rescue url_for(options)
    end
  end
end
