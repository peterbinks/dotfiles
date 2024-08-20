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
        failed_transactions: failed_card_transactions
      )
    end

    def policy
      @policy ||= Portal::BrightPolicy.from_policy_number(params[:id])
    end

    def failed_card_transactions
      return if policy.payment_type != "card"

      @failed_card_transactions = policy.billing_transactions.status_rejected.select do |transaction|
        transaction.updated_at > (policy.credit_card&.updated_at || policy.effective_date)
      end
    end

    def authorize_user
      authorize policy, policy_class: PolicyAuthPolicy
    end
  end
end
