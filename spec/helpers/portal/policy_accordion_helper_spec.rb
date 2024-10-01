require "rails_helper"

describe Portal::PolicyAccordionHelper, domain: :policy_administration, feature: :policy_accordion do
  describe "#render_policy_accordion_component?" do
    context "when a policy has no policy_accordion_steps" do
      it "does not render" do
        policy = build(:policy, policy_accordion_steps: [])

        expect(helper.render_policy_accordion_component?(policy)).to eq(false)
      end
    end

    context "when a policy is passed the goal date and there are only optional steps left" do
      it "does not render" do
        document_1 = build(:document, label: "policy_application", signed_at: DateTime.current - 1.month)
        document_2 = build(:document, label: "declaration_page_step")
        step = build(:policy_accordion_step, step_complete: false, optional: true)

        term = build(:term, number: 0, effective_date: DateTime.current - 1.month)
        policy = build(
          :policy,
          terms: [term],
          documents: [document_1, document_2],
          policy_accordion_steps: [step],
          new_purchase: true
        )

        expect(helper.render_policy_accordion_component?(policy)).to eq(false)
      end
    end

    context "when a policy has policy_accordion_steps" do
      context "and some steps are incomplete" do
        it "renders" do
          step = build(:policy_accordion_step, step_complete: false)
          policy = build(:policy, policy_accordion_steps: [step])

          expect(helper.render_policy_accordion_component?(policy)).to eq(true)
        end
      end

      context "all steps are complete and all relevant documents are reviewed and it is not passed goal date" do
        it "does render" do
          term = 0
          document = build(:document, label: "windstorm_mitigation_form", term: term, review_status: "accepted")
          step = build(:policy_accordion_step, step_complete: true)
          policy = build(
            :policy,
            current_term: term,
            documents: [document],
            policy_accordion_steps: [step]
          )

          expect(helper.render_policy_accordion_component?(policy)).to eq(true)
        end
      end

      context "and all steps are complete but some relevant documents are not reviewed" do
        it "renders" do
          term = 0
          document = build(:document, label: "windstorm_mitigation_form", term: term, review_status: "not_reviewed")
          step = build(:policy_accordion_step, step_complete: true)
          policy = build(
            :policy,
            current_term: term,
            documents: [document],
            policy_accordion_steps: [step]
          )

          expect(helper.render_policy_accordion_component?(policy)).to eq(true)
        end
      end
    end
  end

  describe "#has_completed_all_steps?" do
    it "returns true when all steps are complete" do
      step = build(:policy_accordion_step, step_complete: true)
      policy = build(:policy, policy_accordion_steps: [step])

      expect(helper.has_completed_all_steps?(policy.policy_accordion_steps)).to eq(true)
    end

    it "returns false when some steps are incomplete" do
      step_1 = build(:policy_accordion_step, step_complete: true)
      step_2 = build(:policy_accordion_step, step_complete: false)
      policy = build(:policy, policy_accordion_steps: [step_1, step_2])

      expect(helper.has_completed_all_steps?(policy.policy_accordion_steps)).to eq(false)
    end
  end

  describe "#all_relevant_documents_reviewed?" do
    context "all relevant documents are reviewed" do
      it "does not render" do
        document = build(:document, term: 0, label: "windstorm_mitigation_form", review_status: "accepted")
        policy = build(:policy, current_term: 0, documents: [document])

        expect(helper.all_relevant_documents_reviewed?(policy)).to eq(true)
      end
    end

    context "some relevant documents are not reviewed" do
      it "renders" do
        document = build(:document, term: 0, label: "windstorm_mitigation_form", review_status: "not_reviewed")
        policy = build(:policy, current_term: 0, documents: [document])

        expect(helper.all_relevant_documents_reviewed?(policy)).to eq(false)
      end
    end
  end

  describe "#get_complete_percent" do
    context "when none of the steps are complete" do
      it "shows 0 (percent)" do
        step_1 = build(:policy_accordion_step, step_complete: false)
        step_2 = build(:policy_accordion_step, step_complete: false)
        policy = build(:policy, policy_accordion_steps: [step_1, step_2])

        expect(helper.get_complete_percent(policy.policy_accordion_steps)).to eq(0)
      end
    end

    context "when half of the steps are complete" do
      it "shows 50 (percent)" do
        step_1 = build(:policy_accordion_step, step_complete: true)
        step_2 = build(:policy_accordion_step, step_complete: false)
        policy = build(:policy, policy_accordion_steps: [step_1, step_2])

        expect(helper.get_complete_percent(policy.policy_accordion_steps)).to eq(50)
      end
    end

    context "when all of the steps are complete" do
      it "shows 100 (percent)" do
        step_1 = build(:policy_accordion_step, step_complete: true)
        step_2 = build(:policy_accordion_step, step_complete: true)
        policy = build(:policy, policy_accordion_steps: [step_1, step_2])

        expect(helper.get_complete_percent(policy.policy_accordion_steps)).to eq(100)
      end
    end
  end
end
