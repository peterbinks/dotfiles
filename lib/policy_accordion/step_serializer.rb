module PolicyAccordion
  class StepSerializer
    attr_reader :policies

    # @param policies [BrightPolicy]
    def initialize(policies)
      @policies = policies
    end

    # @return [Hash<JSON>] hash of formatted json for steps for each policy
    def to_a
      policies.each_with_object({}) do |policy, data|
        data[policy.id] = to_json(policy)
      end
    end

    private

    def to_json(policy)
      {
        user_id: policy_user_id(policy),
        steps: policy.policy_accordion_steps
      }.to_json
    end

    def policy_user_id(policy)
      policy.primary_insured.user_id
    end

    def policy_steps(policy)
      policy
        .policy_accordion_steps
        .sort_by { |step| [step.step_complete, step.step_priority] }
        .map(&:step_hash)
    end
  end
end
