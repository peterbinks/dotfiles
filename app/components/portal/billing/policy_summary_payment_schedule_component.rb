module Portal
  # A component that displays the payment schedule for a given policy.
  module Billing
    class PolicySummaryPaymentScheduleComponent < Portal::ViewComponent::Base
      include Portal::ApplicationHelper
      include Portal::BillingTransactionHelper
      include Portal::ModalHelper

      # @return [BrightPolicy] the policy associated with the payment schedule.
      attr_reader :policy, :billing_transactions, :next_upcoming_transaction, :upcoming_endorsement_transactions

      # @param policy [BrightPolicy]
      # @param billing_transactions [ActiveRecord::Collection<Billing::ScheduledTransaction>]
      def initialize(policy:, transactions:)
        @policy = policy
        @billing_transactions = transactions.billing_transactions
        @next_upcoming_transaction = transactions.next_upcoming_transaction
        @upcoming_endorsement_transactions = transactions.upcoming_endorsement_transactions
      end

      # Checks if there are no correct transactions.
      #
      # @return [Boolean]
      def render?
        !billing_corrections_needed?
      end

      # @return [Boolean]
      def billing_corrections_needed?
        ::Billing::Corrector.new(@policy).corrections_needed?
      end

      # Determines the text color for a transaction based on its approval status.
      #
      # @param transaction [Billing::ScheduledTransaction] The transaction to check.
      # @return [String] The CSS class for the text color.
      def disable_text_color(transaction)
        transaction.status_approved? ? "c-neutral-600" : ""
      end

      # Determines whether a policy has an endorsement is in progress.
      #
      # @return [Boolean] true if an endorsement is in progress, false otherwise.

      def show_payment_button?(transaction)
        manual_payments_enabled? &&
          (is_next_upcoming_transaction_installment?(transaction) ||
          is_any_upcoming_transaction_endorsement?(transaction))
      end

      private

      def manual_payments_enabled?
        Feature.active?(:manual_payments_enabled)
      end

      # Determines if the given billing transaction is the next upcoming transaction.
      #
      # @param billing_transaction [Billing::ScheduledTransaction] The billing transaction to check.
      # @return [Boolean] Returns true if the given billing transaction is the next upcoming transaction, otherwise false.
      def is_next_upcoming_transaction?(billing_transaction)
        next_upcoming_transaction == billing_transaction
      end

      # Determines if the given billing transaction is an upcoming endorsement transaction.
      #
      # @param billing_transaction [Billing::ScheduledTransaction] The billing transaction to check.
      # @return [Boolean] Returns true if the given billing transaction an upcoming endorsement transaction, otherwise false.
      def is_any_upcoming_transaction_endorsement?(billing_transaction)
        upcoming_endorsement_transactions.include?(billing_transaction)
      end

      # Determines if there is an endorsement request in progress for the policy.
      #
      # @return [Boolean] true if there is an endorsement request or a renewal endorsement request in progress, false otherwise.
      def endorsement_request_in_progress?
        @endorsement_request_in_progress ||= (@policy.in_progress_endorsement_request? || @policy.in_progress_renewal_endorsement_request?)
      end

      def is_next_upcoming_transaction_installment?(transaction)
        is_next_upcoming_transaction?(transaction) &&
          unsettled_cash_payment?(transaction) &&
          !endorsement_request_in_progress?
      end

      # @param transaction [Billing::ScheduledTransaction]
      # @return [Boolean]
      def unsettled_cash_payment?(transaction)
        %w[upcoming rejected].include?(transaction.status) &&
          %w[scheduled shortpayment reinstatement].include?(transaction.payment_type)
      end
    end
  end
end
