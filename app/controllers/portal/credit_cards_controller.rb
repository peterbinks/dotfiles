module Portal
  class CreditCardsController < PortalController
    before_action :authorize_user
    before_action :set_current_user_to_current_attributes

    DEFAULT_TAGS = {
      source: "portal",
      domain: "customer-service"
    }

    def edit
      load_policy
      load_failed_card_transactions
    end

    def success
      load_policy

      @success_params = success_params
    end

    def error
      load_policy

      @credit_card_updated = params.dig("credit_card_updated").to_bool
    end

    def create
      Portal::Api::CreditCard.create!(
        policy: policy,
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
        policy_number: policy.policy_number,
        value: credit_card_params.dig(:value),
        descriptor: credit_card_params.dig(:descriptor),
        notify_customer: true
      )

      if policy.billing_transactions.any?(&:recently_rejected?)
        Portal::Api::CreditCard.charge_rejected_payments!(policy_number: policy.policy_number)
      end

      if policy.billing_transactions.map(&:recently_rejected?).any?
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
      value, descriptor, transaction_id, save_card, use_saved_card = credit_card_transaction_params.values_at(:value, :descriptor, :transactionId, :saveCard, :useSavedCard)

      raise StandardError.new("NO")
      if use_saved_card == "true"
        PaymentProcessor::ProcessPayment.call(transaction_id, policy, current_user)
      elsif save_card == "true"
        PaymentProcessor::SaveCardAndProcessPayment.call(value, descriptor, transaction_id, policy, current_user)
      else
        PaymentProcessor::ProcessOneTimePayment.call(transaction_id, value, descriptor, current_user)
      end

      render_success("Payment processed successfully.")
    rescue => error
      handle_exception(error, transaction_id)
    end

    private

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

    def policy
      @policy ||= Portal::Api::Policy.get_policy(policy_number: params[:policy_id])
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
      relevant_transaction = policy.billing_transactions.find(&:recently_approved?) || policy.billing_transactions.find(&:recently_rejected?)

      return {} if relevant_transaction.blank?

      {
        card_last_4: policy.credit_card.last_4,
        payment_amount: relevant_transaction.amount_cents / 100.00
      }
    end

    def find_billing_transaction(transaction_id)
      ::Billing::ScheduledTransaction.find(transaction_id)
    end

    def render_success(message)
      render json: {success: message}, status: :ok
    end

    def render_error(message)
      render json: {message: message}, status: :unprocessable_entity
    end

    def handle_exception(error, transaction_id = nil)
      billing_transaction = find_billing_transaction(transaction_id) if transaction_id

      # TODO - make API call
      billing_transaction.status_rejected! if billing_transaction&.upcoming?

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
