module Portal
  class PoliciesController < PortalController
    before_action :load_data
    before_action :authorize_user

    helper Portal::PoliciesHelper

    # GET /portal/policies/:policy_number
    def show
      @page_title = "Details for " + @policy.address.to_s
    end

    private

    def load_data
      @__data = OpenStruct.new(
        policy: policy,
        document: Portal::Document.new(policy).policy_show_page,
        user: current_user,
        failed_transactions: failed_card_transactions
      )
    end

    def failed_card_transactions
      return if policy.payment_type != "card"

      @failed_card_transactions = policy.billing_transactions.status_rejected.select do |transaction|
        transaction.updated_at > (policy.credit_card&.updated_at || policy.effective_date)
      end
    end

    def policy
      @policy ||= BrightPolicy.from_policy_number(params[:id])
    end

    def authorize_user
      authorize policy, policy_class: PolicyAuthPolicy
    end
  end
end
