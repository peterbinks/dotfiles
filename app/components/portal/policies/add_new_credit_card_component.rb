module Portal
  module Policies
    class AddNewCreditCardComponent < Portal::ViewComponent::Base
      include Portal::ApplicationHelper
      include Portal::PoliciesHelper

      attr_reader :policy

      def initialize(policy:)
        @policy = policy
        @client = policy.auth_net_client
        @electronic_fund_transfer_link = electronic_fund_transfer_link_url(policy)
      end
    end
  end
end
