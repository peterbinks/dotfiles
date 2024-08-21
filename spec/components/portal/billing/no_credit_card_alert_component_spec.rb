require "rails_helper"

RSpec.describe Portal::Billing::NoCreditCardAlertComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "The policy does not have a card" do
    context "Payment type is card" do
      it "Should render the component" do
        policy = double(
          "BrightPolicy",
          payment_type: "card",
          credit_card: nil,
          recurring_payment_notice_doc: "link_to_document",
        )

        expect(described_class.new(policy: policy).render?).to be true
      end
    end

    context "Payment type is escrow" do
      it "Should not render the component" do
        policy = double(
          "BrightPolicy",
          payment_type: "escrow",
          credit_card: nil,
          recurring_payment_notice_doc: "link_to_document",
        )

        expect(described_class.new(policy: policy).render?).to be false
      end
    end
  end

  context "The policy does have a card" do
    context "Payment type is card" do
      it "Should not render the component" do
        policy = double(
          "BrightPolicy",
          payment_type: "card",
          credit_card: double("credit_card"),
          recurring_payment_notice_doc: "link_to_document",
        )

        expect(described_class.new(policy: policy).render?).to be false
      end
    end

    context "Payment type is escrow" do
      it "Should not render the component" do
        policy = double(
          "BrightPolicy",
          payment_type: "escrow",
          credit_card: double("credit_card"),
          recurring_payment_notice_doc: "link_to_document",
        )

        expect(described_class.new(policy: policy).render?).to be false
      end
    end
  end
end
