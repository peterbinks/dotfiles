module Portal
  class BillingTransactions
    attr_reader :policy

    def initialize(policy)
      @policy = policy
    end

    # :policies
    def policy_show_page
      @portal_index ||= Portal::Serializers::BillingTransactionsSerializer.new(policy).policy_show_page
    end
  end
end
