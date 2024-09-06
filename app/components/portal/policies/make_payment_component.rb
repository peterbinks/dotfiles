module Portal
  module Policies
    class MakePaymentComponent < Portal::ViewComponent::Base
      include Portal::ApplicationHelper
      include Portal::PoliciesHelper

      attr_reader :policy, :billing_transaction, :client, :electronic_fund_transfer_link

      def initialize(policy:, billing_transaction:)
        @policy = policy
        @billing_transaction = billing_transaction
        @client = policy.auth_net_client
        @electronic_fund_transfer_link = electronic_fund_transfer_link_url(policy)
      end

      def card_present?
        !@policy.credit_card.blank?
      end

      def card_details
        if card_present?
          "************#{@policy.credit_card&.last_4}"
        end
      end
    end
  end
end
