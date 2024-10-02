module Portal
  class RenewalPolicy < Policy
    has_one :coverage

    attribute :id
    attribute :premium
    attribute :flood_premium
  end
end
