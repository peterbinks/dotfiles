module Portal
  class PortalController < ApplicationController
    layout "portal/application"

    delegate :person, to: :current_user, prefix: :current, allow_nil: true

    before_action :authenticate_user!
    before_action :create_person_if_necessary

    def portal_routes
      ::Portal::Engine.routes.url_helpers
    end

    def main_app_routes
      Rails.application.routes.url_helpers
    end

    private

    def create_person_if_necessary
      if current_person.blank?
        redirect_to main_app.edit_portal_account_path, flash: {error: "You need to create an account first."}
      end
    end
  end
end
