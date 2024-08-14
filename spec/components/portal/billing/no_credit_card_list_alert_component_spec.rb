require "rails_helper"

RSpec.describe Portal::Billing::NoCreditCardListAlertComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "one or more policies have no credit card" do
    context "the payment type is 'escrow'" do
      it "does not render" do
        policy = double(
          "BrightPolicy",
          payment_type: "escrow",
          credit_card: nil,
        )

        component = described_class.new(policies: [policy])

        expect(component.render?).to be false
      end
    end

    context "the payment type on at least one policy is 'card'" do
      it "renders" do
        policy_card = double(
          "BrightPolicy",
          payment_type: "card",
          credit_card: nil,
        )
        policy_escrow = double(
          "BrightPolicy",
          payment_type: "escrow",
          credit_card: nil,
        )

        component = described_class.new(policies: [policy_card, policy_escrow])

        expect(component.render?).to be true
      end
    end
  end

  context "all policies have a credit card" do
    it "does not render" do
      policy = double(
        "BrightPolicy",
        payment_type: "card",
        credit_card: true,
      )

      component = described_class.new(policies: [policy])

      expect(component.render?).to be false
    end
  end
end
