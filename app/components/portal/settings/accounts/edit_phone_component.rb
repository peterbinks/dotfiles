module Portal
  module Settings
    module Accounts
      class EditPhoneComponent < Portal::ViewComponent::Base
        include Portal::ApplicationHelper

        def initialize(user:)
          @user = user
        end
      end
    end
  end
end
