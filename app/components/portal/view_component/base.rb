module Portal
  module ViewComponent
    class Base < ::ViewComponent::Base
      def portal_routes
        ::Portal::Engine.routes.url_helpers
      end
    end
  end
end
