require "rails_helper"

RSpec.describe Portal::Billing::BillingCorrectionsAlertComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "billing corrections are needed" do
    it "renders the block" do
      policy = build_stubbed(:bright_policy, :bound)
      subject = described_class.new(policy:)

      allow(subject).to receive(:billing_corrections_needed?).and_return(true)

      render_inline(subject)

      expect(rendered_content).to have_css("[data-rspec='payment-alert-block']")
    end
  end

  context "billing corrections are not needed" do
    it "does not render the block" do
      policy = build_stubbed(:bright_policy, :bound)
      subject = described_class.new(policy:)

      allow(subject).to receive(:billing_corrections_needed?).and_return(false)

      render_inline(subject)

      expect(rendered_content).to_not have_css("[data-rspec='payment-alert-block']")
    end
  end
end
