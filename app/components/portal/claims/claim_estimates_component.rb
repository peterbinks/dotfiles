module Portal
  module Claims
    class ClaimEstimatesComponent < Portal::ViewComponent::Base
      def initialize(estimates:)
        @estimates = estimates.sort { |e1, e2| e2["createdAt"] <=> e1["createdAt"] }
      end
    end
  end
end
