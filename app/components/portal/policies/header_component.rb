module Portal
  module Policies
    class HeaderComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::DocumentsHelper
      include Portal::IconHelper

      def initialize(data:)
        @policy = data.policy
        @user = data.user
        @document = data.document
      end
    end
  end
end
