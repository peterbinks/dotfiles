module Portal
  class CreditCardsController < PortalController
    before_action :authorize_user
    before_action :load_policy
    before_action :set_current_user_to_current_attributes

    DEFAULT_TAGS = {
      source: "portal",
      domain: "customer-service"
    }

    def edit
      load_failed_card_transactions
    end

    def success
      @success_params = success_params
    end

    def error
      @credit_card_updated = params.dig("credit_card_updated").to_bool
    end

    def create
      Portal::Api::CreditCard.create!(
        policy: @policy,
        value: credit_card_params.dig(:value),
        descriptor: credit_card_params.dig(:descriptor),
        notify_customer: true
      )

      render json: {success: "Card saved successfully"}, status: :ok
    rescue => error
      Kin::ExceptionHandler.silence(
        error,
        data: {params:},
        tags: [DEFAULT_TAGS]
      )

      render json: {
        result: {
          status: :error,
          message: error
        }
      }, status: :unprocessable_entity
    end

    def update
      Portal::Api::CreditCard.create!(
        policy_number: @policy.policy_number,
        value: credit_card_params.dig(:value),
        descriptor: credit_card_params.dig(:descriptor),
        notify_customer: true
      )

      if @policy.billing_transactions.any?(&:recently_rejected?)
        Portal::Api::CreditCard.charge_rejected_payments!(policy_number: @policy.policy_number)
      end

      if @policy.billing_transactions.map(&:recently_rejected?).any?
        redirect_to error_policy_credit_card_path(credit_card_updated: true)
      else
        redirect_to success_policy_credit_card_path
      end
    rescue => error
      Kin::ExceptionHandler.silence(
        error,
        data: {params:},
        tags: [DEFAULT_TAGS]
      )

      redirect_to error_policy_credit_card_path(credit_card_updated: false)
    end

    def process_card_payment
      transaction_id = credit_card_transaction_params.dig(:transactionId)

      Portal::Api::BillingTransaction.process_payment!(
        type: process_payment_type,
        transaction_id: transaction_id,
        policy_number: @policy.policy_number,
        user: current_user,
        opaque_values: opaque_value_params
      )

      render_success("Payment processed successfully.")
    rescue => error
      handle_exception(error, transaction_id)
    end

    private

    def process_payment_type
      if credit_card_transaction_params.dig(:useSavedCard) == "true"
        :process
      elsif credit_card_transaction_params.dig(:saveCard) == "true"
        :save_card_and_process
      else
        :process_one_time
      end
    end

    def opaque_value_params
      {
        value: credit_card_transaction_params.dig(:value),
        descriptor: credit_card_transaction_params.dig(:descriptor)
      }.reject { |_, v| v.blank? }
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

    def load_policy
      @policy ||= Portal::Api::Policy.get_policy(policy_number: params[:policy_id])
    end

    def load_failed_card_transactions
      @failed_card_transactions ||= @policy.billing_transactions.select(&:rejected?)
    end

    def credit_card_params
      params.require(:credit_card).permit(:value, :descriptor)
    end

    def credit_card_transaction_params
      params.require(:credit_card_transaction).permit(:value, :descriptor, :transactionId, :saveCard, :useSavedCard)
    end

    def success_params
      relevant_transaction = @policy.billing_transactions.find(&:recently_approved?) || @policy.billing_transactions.find(&:recently_rejected?)

      return {} if relevant_transaction.blank?

      {
        card_last_4: @policy.credit_card.last_4,
        payment_amount: relevant_transaction.amount_cents / 100.00
      }
    end

    def render_success(message)
      render json: {success: message}, status: :ok
    end

    def render_error(message)
      render json: {message: message}, status: :unprocessable_entity
    end

    def handle_exception(error, transaction_id = nil)
      Portal::Api::BillingTransaction.patch!(id: transaction_id, changes: {status: :rejected}) if transaction_id.present?

      Kin::ExceptionHandler.silence(
        error,
        data: {params:},
        tags: [DEFAULT_TAGS]
      )

      render json: {
        result: {
          status: :error,
          message: error.message
        }
      }, status: :unprocessable_entity
    end
  end
end
