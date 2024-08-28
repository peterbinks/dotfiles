module Portal
  module Policies
    class AddNewCreditCardComponent < Portal::ViewComponent::Base
      include Portal::ApplicationHelper

      def initialize(policy:)
        @policy = policy
        @client = policy.auth_net_client
        @electronic_fund_transfer_link = policy.recurring_payment_notice_doc
      end
    end
  end
end
