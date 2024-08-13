module Portal
  module Claims
    class ClaimDetailsComponent < Portal::ViewComponent::Base
      def initialize(claim:, show_header: true, show_cta: true, heading_tag: :h3)
        @claim = claim
        @show_header = show_header
        @show_cta = show_cta
        @heading_tag = heading_tag
      end
    end
  end
end
