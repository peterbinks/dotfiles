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

    def payment_due_date_extended?(billing_transaction, policy)
      ProtectionPeriod.rescheduled_transactions_for_policy(policy.id).include?(billing_transaction.id)
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
