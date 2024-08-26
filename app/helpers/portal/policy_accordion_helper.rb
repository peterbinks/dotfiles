module Portal
  module PolicyAccordionHelper
    POLICY_ACCORDION_STEP_DOCUMENTS = %w[
      windstorm_mitigation_form
      roof_permit
    ]

    # @param policy [BrightPolicy]
    # @return [Boolean] renders if any step is incomplete or any relevant documents is not reviewed; otherwise does not render
    def render_policy_accordion_component?(policy)
      steps = policy&.policy_accordion_steps

      return false if policy.was_in_force
      return false if steps.blank?
      return false if past_goal_date?(policy) && all_remaining_steps_are_optional?(steps)
      return false if has_completed_all_steps?(steps) && all_relevant_documents_reviewed?(policy) && past_goal_date?(policy)
      return false if has_closed_policy_prep?(policy)

      true
    end

    # @param step [PolicyAccordion::Step]
    # @return [Boolean] whether all steps are marked `step_complete`
    def has_completed_all_steps?(steps)
      return true if steps.blank?

      steps.all?(&:step_complete?)
    end

    # @param step [PolicyAccordion::Step]
    # @return [Boolean] whether all steps are considered "optional`
    def all_remaining_steps_are_optional?(steps)
      return false if steps.blank?

      steps.where(step_complete: false).all?(&:optional)
    end

    # @param policy [BrightPolicy]
    # @return [Boolean] whether all relevant documents have been reviewed
    def all_relevant_documents_reviewed?(policy)
      policy
        .documents
        .where(term: policy.term, label: POLICY_ACCORDION_STEP_DOCUMENTS)
        .where.not(review_status: "accepted")
        .blank?
    end

    # @param step [PolicyAccordion::Step]
    # @return [Integer] percentage number of how many steps are marked `step_complete`
    def get_complete_percent(steps)
      return if steps.blank?

      completed_steps = steps.where(step_complete: true)
      ((completed_steps.length.to_f / steps.length.to_f) * 100).floor
    end

    # @param policy [BrightPolicy]
    # @return [Boolean] whether any required steps are remaining
    def any_required_steps_remaining?(policy)
      policy.policy_accordion_steps.where(step_complete: false, optional: false).any?
    end

    # @param policy [BrightPolicy]
    # @return [Integer] the number of days remaining to complete steps
    def days_remaining(policy)
      PolicyAccordion::Utils.days_remaining(policy)
    end

    # @param policy [BrightPolicy]
    # @return [Boolean] if there are no days remaining to complete steps
    def no_days_remaining?(policy)
      days_remaining(policy) <= 0
    end

    # @param policy [BrightPolicy]
    # @return [Boolean] if goal date has passed
    def past_goal_date?(policy)
      Date.current > PolicyAccordion::Utils.deadline(policy)
    end

    def has_closed_policy_prep?(policy)
      policy.policy_activities.find_by(name: "policy_prep_component_closed")&.persisted?
    end
  end
end
