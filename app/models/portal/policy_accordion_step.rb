module Portal
  class PolicyAccordionStep < Base
    attribute :user_id
    attribute :step_name
    attribute :step_complete
    attribute :step_description
    attribute :step_priority
    attribute :step_hash
    attribute :optional

    def initialize(step)
      return if step.nil?

      super
    end
  end
end
