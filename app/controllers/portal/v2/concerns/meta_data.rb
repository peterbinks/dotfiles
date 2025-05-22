module Portal
  module V2
    module MetaData
      extend ActiveSupport::Concern

      included do
        before_action :set_default_meta_data
        helper_method :canonical_url
      end

      # ----------------------------------------------------------------------------
      # Set default meta data
      #
      # The values set here will be used for the site meta data unless they are
      # overridden in a controller method.
      #
      # Example:
      #
      # def show
      #   @meta_data.merge!({
      #     title: "New Title",
      #     description: "New description here" })
      # end
      # ----------------------------------------------------------------------------

      def set_default_meta_data
        @meta_data = {
          title: text("site.tagline"),
          description: text("site.description"),
          og_title: text("site.tagline"),
          og_description: text("site.description"),
          og_type: "website",
          og_image: "cards/fb.jpg",
          og_sitename: text("site.name_full"),
          twit_title: text("site.tagline"),
          twit_account: "@kinsured",
          twit_description: text("site.description"),
          twit_card: "summary_large_image",
          twit_image: "cards/twitter.jpg"
        }
      end

      # ----------------------------------------------------------------------------
      # Private: Sets the canonical URL for the requested page.
      #
      # Returns a String.
      # ----------------------------------------------------------------------------

      def canonical_url
        @canonical_url ||= url_for(
          controller: params[:controller],
          action: params[:action],
          id: params[:id],
          protocol: request.protocol,
          only_path: false
        )
      end
    end
  end
end
