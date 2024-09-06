module Portal
  module Api
    class CreditCard
      def self.create!(policy_number:, value:, descriptor:, notify_customer:)
        Portal::Api::CreditCardSerializer.create!(policy_number:, value:, descriptor:, notify_customer:)
      end

      def self.charge_rejected_payments!(policy_number:)
        Portal::Api::CreditCardSerializer.charge_rejected_payments!(policy_number:)
      end
    end
  end
end
