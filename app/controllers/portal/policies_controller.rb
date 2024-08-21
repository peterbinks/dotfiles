module Portal
  class PoliciesController < PortalController
    before_action :load_show_data
    before_action :authorize_user

    helper Portal::PoliciesHelper

    # GET /portal/policies/:policy_number
    def show
      @page_title = "Details for " + @policy.address.to_s
    end

    private

    def load_show_data
      @__data = OpenStruct.new(
        policy: policy,
        document: Portal::Document.new(policy).policy_show_page,
        user: current_user,
        transactions: Portal::BillingTransactions.new(policy).policy_show_page
      )
    end

    def policy
      @policy ||= Portal::BrightPolicy.from_policy_number(params[:id])
    end

    def authorize_user
      authorize policy, policy_class: PolicyAuthPolicy
    end
  end
end
