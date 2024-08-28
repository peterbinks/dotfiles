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
      load_policy
      load_user
      load_failed_card_transactions
    end

    def load_policy
      @policy ||= Portal::Policy.get_policy(policy_number: params[:id])
    end

    def load_user
      @user ||= current_user
    end

    def load_failed_card_transactions
      @failed_card_transactions ||= Portal::BillingTransaction.failed_card_transactions_for_policy(policy_id: @policy.id)
    end

    def authorize_user
      @user.has_role?(:admin) ||
        @user.has_role?(:impersonation) ||
        expected_users.include?(@user)
    end

    def expected_users
      @expected_users ||= [
        @policy.primary_insured.user,
        @policy.co_applicant&.user
      ].compact
    end
  end
end
