require "rails_helper"

RSpec.describe Portal::Policies::MakePaymentComponent, type: :component do
  before do
    allow(AuthNet::Client).to receive(:new) { double("AuthClient", generate_public_client_key: "waka", login_id: "dori") }
  end

  context "when initialized" do
    it "renders the form with the correct elements" do
      recurring_payment_notice_doc_url = [double("Document", expiring_url: "http://example.com/eft_authorization")]
      policy = build_stubbed(:bright_policy, :bound, policy_number: "KIN-HO-FL-248835486")
      allow(policy).to receive(:recurring_payment_notice_doc_url) { recurring_payment_notice_doc_url }
      billing_transaction = build_stubbed(:billing_transaction)
      component = described_class.new(policy: policy, billing_transaction: billing_transaction)

      render_inline(component)

      expect(page).to have_selector("kin-dialog#makePaymentModal")
      expect(rendered_content).to have_css("[data-rspec='make-payment-header']")
      expect(rendered_content).to have_css("[data-rspec='number']")
      expect(rendered_content).to have_css("[data-rspec='expiration']")
      expect(rendered_content).to have_css("[data-rspec='cvv']")
      expect(rendered_content).to have_css("[data-rspec='zip']")
      expect(rendered_content).to have_css("[data-rspec='save-card-checkbox']")
      expect(rendered_content).to have_css("[data-rspec='electronics-transfer-link']")
    end
  end

  context "#card_present?" do
    it "returns true if credit card is present" do
      policy = build_stubbed(:bright_policy, :bound, policy_number: "KIN-HO-FL-248835486")
      billing_transaction = build_stubbed(:billing_transaction)
      component = described_class.new(policy: policy, billing_transaction: billing_transaction)

      allow(policy).to receive(:credit_card).and_return("1234567890123456")
      expect(component.card_present?).to be true
    end

    it "returns false if credit card is blank" do
      policy = build_stubbed(:bright_policy, :bound, policy_number: "KIN-HO-FL-248835486")
      billing_transaction = build_stubbed(:billing_transaction)
      component = described_class.new(policy: policy, billing_transaction: billing_transaction)

      allow(policy).to receive(:credit_card).and_return("")
      expect(component.card_present?).to be false
    end
  end

  context "#card_details" do
    it "returns masked credit card number if card is present" do
      policy = build_stubbed(:bright_policy, :bound, policy_number: "KIN-HO-FL-248835486")
      billing_transaction = build_stubbed(:billing_transaction)
      component = described_class.new(policy: policy, billing_transaction: billing_transaction)

      credit_card = double("credit_card", last_4: "3456")
      allow(policy).to receive(:credit_card).and_return(credit_card)

      expect(component.card_details).to eq "************3456"
    end

    it "returns nil if card is not present" do
      policy = build_stubbed(:bright_policy, :bound, policy_number: "KIN-HO-FL-248835486")
      billing_transaction = build_stubbed(:billing_transaction)
      component = described_class.new(policy: policy, billing_transaction: billing_transaction)

      allow(policy).to receive(:credit_card).and_return("")
      expect(component.card_details).to be_nil
    end
  end
end
