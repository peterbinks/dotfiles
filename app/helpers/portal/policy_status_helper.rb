module Portal
  module PolicyStatusHelper
    # Returns the text for the given policy's status in the portal.
    #
    # @param policy [Policy] The policy.
    # @return [Array(String, String)] The text to be displayed for the policy's
    #   status.
    def portal_policy_status_text(policy)
      portal_policy_status_text_and_style(policy).first
    end

    # Returns the styling for the given policy's status in the portal.
    #
    # @param policy [Policy] The policy.
    # @return [Array(String, String)] The pill variant style to be displayed for
    #   the policy's status.
    def portal_policy_status_style(policy)
      portal_policy_status_text_and_style(policy).second
    end

    # Returns the text and styling for the given policy's status in the portal.
    #
    # @param policy [Policy] The policy.
    # @return [Array(String, String)] The text and pill variant style to be
    #   displayed for the policy's status.
    def portal_policy_status_text_and_style(policy)
      return ["Signed", "primary"] if policy.active_application&.signed? && policy.quote?
      return ["Pending cancellation", "warning"] if policy.pending_cancellation.present?

      case policy.status
      when "bound"
        ["Active on #{policy.effective_date.to_s(:kin_date)}", "primary"]
      when "in_force"
        ["Active", "secondary"]
      when "cancelled"
        ["Inactive", "info"]
      when "non_renewed"
        ["Inactive", "info"]
      when "expired"
        ["Inactive", "info"]
      else
        [policy.status.humanize, "primary"]
      end
    end
  end
end
