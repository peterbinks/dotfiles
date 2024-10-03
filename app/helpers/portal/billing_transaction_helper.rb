module Portal
  module BillingTransactionHelper
    # @param billing_transaction [Billing::ScheduledTransaction]
    # @return [String] The display string for the payment type
    def payment_type_to_display(billing_transaction)
      payment_type = if billing_transaction.endorsement_request_id.present? || billing_transaction.renewal_endorsement_request_id.present?
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

      reinstatement_number = billing_transaction.term_reinstatement_count
      num_installments_for_term = billing_transaction.term_installment_count

      I18n.t("views.billing.#{payment_type}.description",
        installment_number: billing_transaction.installment_number,
        total: num_installments_for_term,
        reinstatement_number: reinstatement_number)
    end

    def payment_due_date_extended?(billing_transaction, policy)
      # TODO: Implement this method

      # ProtectionPeriod.rescheduled_transactions_for_policy(policy.id).include?(billing_transaction.id)

      false
    end
  end
end
