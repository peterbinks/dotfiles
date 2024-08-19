module Portal
  module Policies
    class AddNewCreditCardComponent < Portal::ViewComponent::Base
      include Portal::ApplicationHelper

      def initialize(policy:)
        @policy = policy
        @client = Portal::AuthNet::Client.new(account: policy.product.merchant_account)
        @electronic_fund_transfer_link = policy.recurring_payment_notice_doc.last
      end
    end
  end
end
