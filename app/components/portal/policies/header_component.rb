module Portal
  module Policies
    class HeaderComponent < Portal::ViewComponent::Base
      include Portal::PoliciesHelper
      include Portal::DocumentsHelper
      include Portal::IconHelper

      def initialize(policy:)
        @policy = policy
      end
    end
  end
end
