module PolicyAccordion
  module Utils
    SECONDS_IN_DAY = 24 * 60 * 60

    # @param policy [BrightPolicy]
    # @param step_name [String], e.gs., "Save Declarations Page", "Set Account Password", "Sign Kin Policy"
    # @return [PolicyAccordion::Step]
    def self.find_step(policy, step_name)
      PolicyAccordion::Step.find_by(bright_policy_id: policy.id, step_name: step_name) ||
        PolicyAccordion::Step::NullStep.new(bright_policy: policy)
    end

    # @param policy [BrightPolicy]
    # @return [Integer] the number of days remaining to complete steps
    def self.days_remaining(policy)
      (deadline(policy) - DateTime.current.end_of_day).to_i / SECONDS_IN_DAY
    end

    # @param policy [BrightPolicy]
    # @return [Integer] how many days until the steps are overdue
    def self.deadline(policy)
      if policy.new_purchase == true
        (policy.effective_date.in_time_zone || DateTime.current).end_of_day + 7.days
      else
        (policy.active_application&.signed_at || DateTime.current).end_of_day + 7.days
      end
    end
  end
end
