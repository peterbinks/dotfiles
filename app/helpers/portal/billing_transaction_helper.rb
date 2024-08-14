module Portal
  module BillingTransactionHelper
    # @param billing_transaction [Billing::ScheduledTransaction]
    # @return [String] The display string for the payment type
    def payment_type_to_display(billing_transaction, payment_type: nil, payment_schedule: nil)
      payment_type = if payment_type
        payment_type
      elsif billing_transaction.endorsement_request.present? || billing_transaction.renewal_endorsement_request.present?
        "endorsement_" + billing_transaction.payment_type
      elsif billing_transaction.description == "Cancellation Write Off Payment"
        "cancellation_" + billing_transaction.payment_type
      elsif billing_transaction.description == "Shortpayment Write Off"
        "shortpayment_" + billing_transaction.payment_type
      elsif billing_transaction.scheduled? && billing_transaction.installment_number.nil?
        billing_transaction.payment_type + "_non_installment"
      else
        billing_transaction.payment_type
      end

      reinstatement_number = billing_transaction.transactions_for_same_policy_term.where(payment_type: :reinstatement).count
      num_installments_for_term = payment_schedule || installment_count_for(billing_transaction)

      I18n.t("views.kintranet.billing.#{payment_type}.description",
        installment_number: billing_transaction.installment_number,
        total: num_installments_for_term,
        reinstatement_number: reinstatement_number)
    end

    def payment_form_type(billing_transaction, policy)
      if billing_transaction_refund_by_check?(billing_transaction)
        "escrow"
      else
        policy.payment_type
      end
    end

    def payment_due_date_extended?(billing_transaction, policy)
      ProtectionPeriod.rescheduled_transactions_for_policy(policy.id).include?(billing_transaction.id)
    end

    def billing_transaction_refund_by_check?(billing_transaction)
      user = User.find_by(email: "checks@kin.com")

      return false unless user

      (billing_transaction&.refund? &&
        billing_transaction&.status_approved? &&
        billing_transaction&.approved_by == user)
    end

    # Returns true or false if the policy must be refunded by check or not
    # Authorize.net has a 180 days restriction to be a valid refund via CC
    # so in this case could be refunded by CC only for Check
    #
    # @note We need to filter out transactions that do not have an approved_at date.
    # @param policy [BrightPolicy] the policy which is being refunded
    # @return [Boolean]
    def must_refund_by_check?(policy)
      last_approved_transaction = policy.billing_transactions
        .status_approved
        .where.not(approved_at: nil)
        .order(approved_at: :desc)
        .first

      return true unless last_approved_transaction.presence&.deposited_on

      last_approved_transaction.presence.deposited_on < 180.days.ago
    end

    def disabled_refund_method(policy)
      if must_refund_by_check?(policy)
        %w[credit_card]
      else
        []
      end
    end

    # @param billing_transaction [Billing::ScheduledTransaction] The relevant transaction
    # @param quote [Boolean] whether or not the policy is in quote stage
    # @return [Array<String>] A list of Billing::ScheduledTransaction payment types
    #
    # Exists solely to make sure no waived refunds are applied to quotes
    def available_payment_types_for_policy(billing_transaction, quote)
      types = %w[scheduled write_off refund duplicate shortpayment]
      types << "waived_refund" unless quote
      types << billing_transaction.payment_type unless types.include?(billing_transaction.payment_type)
      types
    end

    def transaction_display(transaction)
      "#{number_to_currency(transaction.amount)} - #{payment_type_to_display(transaction)}"
    end

    private

    # If the transaction is a scheduled transaction, we can just count its fellow
    # installments.
    #
    # We only make draft transactions for non-approved installments, and so to get
    # the correct count, we add the approved scheduled installment count to it.
    def installment_count_for(transaction)
      installments = transaction.transactions_for_same_policy_term
        .scheduled
        .where(endorsement_request: nil)
        .where.not(installment_number: nil)

      if transaction.draft?
        transaction.bright_policy.billing_transactions
          .scheduled
          .status_approved
          .for_term(transaction.term)
          .where(endorsement_request: nil)
          .where.not(installment_number: nil)
          .count + installments.count
      else
        installments.count
      end
    end
  end
end
