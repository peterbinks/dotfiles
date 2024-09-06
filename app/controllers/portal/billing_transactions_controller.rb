module Portal
  class BillingTransactionsController < PortalController
    before_action :authorize_user

    def download_receipt
      file_path = Portal::Api::Document.get_file_path(id: billing_transaction&.receipt&.id)

      if file_path
        send_data(file_path, filename: "receipt_#{billing_transaction.approved_at&.to_s(:kin_datetime)}.pdf", content_type: "application/pdf")
      else
        redirect_to portal_routes.policy_path(policy.policy_number), alert: "Receipt not found"
      end
    end

    private

    def policy
      @policy ||= Portal::Api::Policy.get_policy(policy_number: params[:policy_id])
    end

    def billing_transaction
      @billing_transaction ||= Portal::Api::BillingTransaction.get_transaction(id: params[:id])
    end

    def authorize_user
      current_user.has_role?(:admin) ||
        current_user.has_role?(:impersonation) ||
        applicants_for_auth.map(&:user_id).include?(current_user&.id)
    end

    # Fetching applicants directly rather than through the policy so we authorize the user
    # before we load their policy info
    def applicants_for_auth
      @applicants_for_auth ||= Portal::Api::Applicant.get_applicants(policy_number: params[:policy_id])
    end
  end
end
