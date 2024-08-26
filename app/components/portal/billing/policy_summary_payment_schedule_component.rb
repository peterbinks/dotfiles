module Portal
  # A component that displays the payment schedule for a given policy.
  module Billing
    class PolicySummaryPaymentScheduleComponent < ViewComponent::Base
      include Portal::ApplicationHelper
      include Portal::BillingTransactionHelper
      include Portal::ModalHelper

      # @return [BrightPolicy] the policy associated with the payment schedule.
      attr_reader :policy

      # @param policy [BrightPolicy]
      def initialize(policy:)
        @policy = policy
      end

      # Checks if there are no correct transactions.
      #
      # @return [Boolean]
      def render?
        !billing_corrections_needed?
      end

      # The billing transactions associated with this policy.
      #
      # @return [ActiveRecord::Relation<Billing::ScheduledTransaction>]
      def billing_transactions
        @policy
          .billing_transactions
          .includes(:payment, :endorsement_request, :renewal_endorsement_request, :checkbook_io_response, :approved_by)
          .order(term: :asc, due_date: :asc)
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
        upcoming_transaction == billing_transaction
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

      # Returns the next upcoming transaction for the policy's term.
      #
      # @return [Billing::ScheduledTransaction, nil] The next upcoming transaction, or nil if none exists.
      def upcoming_transaction
        @upcoming_transaction ||=
          @policy.billing_transactions.upcoming_for_term(@policy.term).or(
            @policy.billing_transactions.rejected_for_term(@policy.term)
          ).where(endorsement_request: nil).sequential.first
      end

      # Returns all upcoming endorsement transactions for the policy.
      #
      # @return [Array<Billing::ScheduledTransaction>] The array of next upcoming endorsement transactions, or `nil` if none is found.
      def upcoming_endorsement_transactions
        @upcoming_endorsement_transactions ||=
          @policy.billing_transactions.upcoming_for_term(@policy.term).where.not(endorsement_request: nil).to_a
      end
    end
  end
end
