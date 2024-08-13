module Portal
  class PoliciesController < PortalController
    before_action :load_policy
    before_action :authorize_user

    helper Portal::PoliciesHelper

    def show
      @page_title = "Details for " + @policy.address.to_s
      set_failed_card_transactions
    end

    private

    def set_failed_card_transactions
      return if @policy.payment_type != "card"
      @failed_transactions = @policy.billing_transactions.status_rejected.select do |transaction|
        transaction.updated_at > (@policy.credit_card&.updated_at || @policy.effective_date)
      end
    end

    def load_policy
      @policy = BrightPolicy.from_policy_number(params[:id])
    end

    def authorize_user
      authorize @policy, policy_class: PolicyAuthPolicy
    end
  end
end
