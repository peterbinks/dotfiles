require "rails_helper"

RSpec.describe Portal::Billing::PaymentMethod::EscrowComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "payment type is escrow" do
    it "renders payment type block" do
      policy = double("BrightPolicy", payment_type_escrow?: true)

      render_inline(described_class.new(policy:))

      expect(rendered_content).to have_css("[data-rspec='escrow-payment-block']", text: "Payment Method - Escrow")
    end
  end

  context "payment type is not escrow" do
    it "does not render payment type block" do
      policy = double("BrightPolicy", payment_type_escrow?: false)

      render_inline(described_class.new(policy:))

      expect(described_class.new(policy:).render?).to be false
    end
  end
end
