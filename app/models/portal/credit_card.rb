module Portal
  class CreditCard < Base
    attribute :id
    attribute :last_4
    attribute :exp_month
    attribute :exp_year

    def initialize(credit_card)
      return if credit_card.nil?

      super
    end
  end
end
