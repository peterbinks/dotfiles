module Portal
  module Api
    class CreditCard < Base
      dotcom_api Portal::Api::Actions::CreditCards

      def self.create!(policy_number:, value:, descriptor:, notify_customer:)
        DotcomAPI::Create.request(policy_number:, value:, descriptor:, notify_customer:)
      end

      def self.charge_rejected_payments!(policy_number:)
        DotcomAPI::ChargeRejectedPayments.request(policy_number:)
      end
    end
  end
end
