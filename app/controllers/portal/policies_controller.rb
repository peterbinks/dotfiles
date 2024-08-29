module Portal
  class PoliciesController < PortalController
    before_action :authorize_user
    before_action :load_show_data

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
      @policy ||= Portal::Api::Policy.get_policy(policy_number: params[:id])
    end

    def load_user
      @user ||= current_user
    end

    def load_failed_card_transactions
      # @failed_card_transactions ||= Portal::BillingTransaction.failed_card_transactions_for_policy(policy_id: @policy.id)
      @failed_card_transactions ||= @policy.billing_transactions.select do |transaction|
        transaction.status == "rejected" &&
          transaction.updated_at > (@policy.credit_card&.updated_at || @policy.effective_date)
      end
    end

    def authorize_user
      current_user.has_role?(:admin) ||
        current_user.has_role?(:impersonation) ||
        applicants_for_auth.map(&:user_id).include?(current_user&.id)
    end

    # Fetching applicants directly rather than through the policy so we authorize the user
    # before we load their policy info
    def applicants_for_auth
      @applicants_for_auth ||= Portal::Api::Applicant.get_applicants(policy_number: params[:id])
    end
  end
end
