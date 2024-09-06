require "rails_helper"

RSpec.describe Portal::Policies::PolicySummaryComponent, domain: :policy_administration, type: :component, feature: :portal do
  def render_component(policy)
    render_inline(described_class.new(policy: policy))
  end

  context "on my policies page" do
    let(:policy) { create(:bright_policy, :with_primary_insured) }
    let(:cancelled_policy) { create(:bright_policy, :with_primary_insured, :cancelled) }

    it "does not render policy change button" do
      render_component(policy)

      expect(rendered_content).not_to have_css('a[href="https://support.kin.com/contact/submit-request-BynGK5BkF"]', text: "Request Policy Change")
    end

    it "renders the formatted premium amount" do
      render_component(policy)

      expect(rendered_content).to have_css("[data-rspec='premium_quote']", text: "$3,675")
    end

    it "renders superscript cents for formatted premium amount" do
      render_component(policy)

      expect(rendered_content).to have_css("[data-rspec='premium_quote'] span", text: "00")
    end

    it "renders cancelled policies" do
      render_component(cancelled_policy)

      expect(rendered_content).to have_css("[data-rspec='quote_status']", text: "Inactive")
    end
  end

  context "when the policy is about to expire" do
    context "and the renewal status is renew" do
      let(:renewal_policy) { create(:bright_policy, :with_primary_insured, effective_date: Date.current - 350.days) }

      before do
        create(:effective_policy_snapshot, :renewal_snapshot, :with_frozen_rating, bright_policy: renewal_policy)
        create(:document, label: "declaration_page", show_in_portal: true, documentable: renewal_policy, person: renewal_policy.primary_insured, updated_at: 30.minutes.ago, term: 1)
        create(:document, label: "declaration_page", show_in_portal: true, documentable: renewal_policy, person: renewal_policy.primary_insured, updated_at: 5.minutes.ago, term: 0)
      end

      it "renders new renewal premium text" do
        render_component(renewal_policy)

        expect(rendered_content).to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
      end

      it "renders the formatted premium amount" do
        render_component(renewal_policy)

        expect(rendered_content).to have_css("[data-rspec='upcoming_amount']", text: "$1,727")
      end

      it "renders superscript cents for formatted premium amount" do
        render_component(renewal_policy)

        expect(rendered_content).to have_css("[data-rspec='upcoming_amount'] span", text: "00")
      end
    end

    context "and the renewal status is do_not_renew" do
      let(:do_not_renew_policy) { create(:bright_policy, :with_primary_insured, :do_not_renew) }

      it "does not render new renewal premium text" do
        render_component(do_not_renew_policy)

        expect(rendered_content).not_to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
      end
    end
  end

  context "when the policy is not about to expire" do
    let(:about_to_expire_policy) { create(:bright_policy, :with_primary_insured) }

    it "does not render new renewal premium text" do
      render_component(about_to_expire_policy)

      expect(rendered_content).not_to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
    end
  end

  context "when the policy is non_renewed" do
    context "and the renewal status is do_not_renew" do
      let(:non_renewed_policy) { create(:bright_policy, :with_primary_insured, effective_date: Date.current - 370.days) }

      before do
        create(:document, label: "declaration_page", show_in_portal: true, documentable: non_renewed_policy, person: non_renewed_policy.primary_insured, updated_at: 30.minutes.ago, term: 1)
        create(:document, label: "declaration_page", show_in_portal: true, documentable: non_renewed_policy, person: non_renewed_policy.primary_insured, updated_at: 5.minutes.ago, term: 0)
      end

      it "renders term 0 premium text" do
        render_component(non_renewed_policy)

        expect(rendered_content).to have_css("[data-rspec='premium_quote']", text: "$3,675")
      end

      it "does not render the upcoming premium text" do
        render_component(non_renewed_policy)

        expect(rendered_content).not_to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
      end
    end
  end
end
