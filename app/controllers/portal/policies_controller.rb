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
        user: current_user,
        failed_card_transactions: Portal::BillingTransaction.failed_card_transactions_for_policy(policy_id: policy.id)
      )
    end

    def policy
      @policy ||= Portal::Policy.get_policy(policy_number: params[:id])
    end

    def authorize_user
      current_user.has_role?(:admin) ||
      current_user.has_role?(:impersonation) ||
        expected_users.include?(current_user)
    end

    def expected_users
      @expected_users ||= [
        policy.primary_insured.user,
        policy.co_applicant&.user
      ].compact
    end
  end
end
