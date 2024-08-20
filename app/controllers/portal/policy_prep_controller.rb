module Portal
  class HomeController < PortalController
    before_action :load_close_policy_prep_component_data

    helper Portal::PolicyAccordionHelper

    # POST /portal/close_policy_prep_component
    def close_policy_prep_component
      @__data.policy.record_activity(:policy_prep_component_closed, whodunnit: current_person.id)

      redirect_to "/portal"
    end

    private

    def load_close_policy_prep_component_data
      @__data = OpenStruct.new(
        policy: Portal::BrightPolicy.find(params[:bright_policy_id])
      )
    end
  end
end
