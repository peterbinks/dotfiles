require "rails_helper"

describe Portal::PolicyAccordionHelper, domain: :policy_administration, feature: :policy_accordion do
  describe "#render_policy_accordion_component?" do
    context "when a policy has no policy_accordion_steps" do
      it "does not render" do
        policy = create(:bright_policy, :with_primary_insured)

        expect(helper.render_policy_accordion_component?(policy)).to eq(false)
      end
    end

    context "when a policy is passed the goal date and there are only optional steps left" do
      it "does not render" do
        policy = create(:bright_policy, :with_primary_insured)

        create(:policy_application, signed_at: DateTime.current - 1.month, bright_policy: policy)

        create(:declaration_page_step, bright_policy: policy, user: policy.primary_insured.user)

        expect(helper.render_policy_accordion_component?(policy)).to eq(false)
      end
    end

    context "when a policy has policy_accordion_steps" do
      context "and some steps are incomplete" do
        it "renders" do
          policy = create(:bright_policy, :with_primary_insured)

          create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: false)

          expect(helper.render_policy_accordion_component?(policy)).to eq(true)
        end
      end

      context "all steps are complete and all relevant documents are reviewed and it is not passed goal date" do
        it "does render" do
          policy = create(:bright_policy, :with_primary_insured)

          create(:document, label: "windstorm_mitigation_form", term: policy.current_term, documentable: policy, review_status: "accepted")
          create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: true)

          expect(helper.render_policy_accordion_component?(policy)).to eq(true)
        end
      end

      context "and all steps are complete but some relevant documents are not reviewed" do
        it "renders" do
          policy = create(:bright_policy, :with_primary_insured)

          create(:document, label: "windstorm_mitigation_form", term: policy.current_term, documentable: policy, review_status: "not_reviewed")
          create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: true)

          expect(helper.render_policy_accordion_component?(policy)).to eq(true)
        end
      end
    end
  end

  describe "#has_completed_all_steps?" do
    it "returns true when all steps are complete" do
      policy = create(:bright_policy, :with_primary_insured)
      create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: true)

      expect(helper.has_completed_all_steps?(policy.policy_accordion_steps)).to eq(true)
    end

    it "returns false when some steps are incomplete" do
      policy = create(:bright_policy, :with_primary_insured)
      create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: true)
      create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: false)

      expect(helper.has_completed_all_steps?(policy.policy_accordion_steps)).to eq(false)
    end
  end

  describe "#all_relevant_documents_reviewed?" do
    context "all relevant documents are reviewed" do
      it "does not render" do
        policy = create(:bright_policy, :with_primary_insured)
        create(:document, label: "windstorm_mitigation_form", term: policy.current_term, documentable: policy, review_status: "accepted")

        expect(helper.all_relevant_documents_reviewed?(policy)).to eq(true)
      end
    end

    context "some relevant documents are not reviewed" do
      it "renders" do
        policy = create(:bright_policy, :with_primary_insured)
        create(:document, label: "windstorm_mitigation_form", term: policy.current_term, documentable: policy, review_status: "not_reviewed")

        expect(helper.all_relevant_documents_reviewed?(policy)).to eq(false)
      end
    end
  end

  describe "#get_complete_percent" do
    context "when none of the steps are complete" do
      it "shows 0 (percent)" do
        policy = create(:bright_policy, :with_primary_insured)
        create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: false)
        create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: false)

        expect(helper.get_complete_percent(policy.policy_accordion_steps)).to eq(0)
      end
    end

    context "when half of the steps are complete" do
      it "shows 50 (percent)" do
        policy = create(:bright_policy, :with_primary_insured)
        create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: true)
        create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: false)

        expect(helper.get_complete_percent(policy.policy_accordion_steps)).to eq(50)
      end
    end

    context "when all of the steps are complete" do
      it "shows 100 (percent)" do
        policy = create(:bright_policy, :with_primary_insured)
        create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: true)
        create(:policy_accordion_step, bright_policy: policy, user: policy.primary_insured.user, step_complete: true)

        expect(helper.get_complete_percent(policy.policy_accordion_steps)).to eq(100)
      end
    end
  end
end
