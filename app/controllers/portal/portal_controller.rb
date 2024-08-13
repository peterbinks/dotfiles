module Portal
  class PortalController < ApplicationController
    layout "application_portal"

    # delegate :person, to: :current_user, prefix: :current, allow_nil: true

    # before_action :authenticate_user!
    # before_action :create_person_if_necessary

    # prepend_view_path("subsystems/portal/views")

    # private

    # def create_person_if_necessary
    #   if current_person.blank?
    #     redirect_to main_app.edit_portal_account_path, flash: {error: "You need to create an account first."}
    #   end
    # end
  end
end
