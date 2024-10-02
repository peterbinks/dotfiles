require "rails_helper"

RSpec.describe Portal::Policies::MakePaymentComponent, type: :component do
  context "when initialized" do
    it "renders the form with the correct elements" do
      client = double("client", login_id: "login_id", generate_public_client_key: "generate_public_client_key")
      billing_transaction = build(:billing_transaction, due_date: Date.current)
      policy = build(:policy,
        recurring_payment_notice_doc_url: "http://example.com",
        billing_transactions: [billing_transaction],
        auth_net_client: client)

      component = described_class.new(policy:, billing_transaction:)

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
      billing_transaction = build(:billing_transaction, due_date: Date.current)
      credit_card = build(:credit_card)
      policy = build(:policy,
        recurring_payment_notice_doc_url: "http://example.com",
        billing_transactions: [billing_transaction],
        credit_card: credit_card)

      component = described_class.new(policy:, billing_transaction:)

      allow(policy).to receive(:credit_card).and_return("1234567890123456")
      expect(component.card_present?).to be true
    end

    it "returns false if credit card is blank" do
      billing_transaction = build(:billing_transaction, due_date: Date.current)
      policy = build(:policy,
        recurring_payment_notice_doc_url: "http://example.com",
        billing_transactions: [billing_transaction],
        credit_card: nil)

      component = described_class.new(policy:, billing_transaction:)

      expect(component.card_present?).to be false
    end
  end

  context "#card_details" do
    it "returns masked credit card number if card is present" do
      billing_transaction = build(:billing_transaction, due_date: Date.current)
      credit_card = build(:credit_card, last_4: "3456")
      policy = build(:policy,
        recurring_payment_notice_doc_url: "http://example.com",
        billing_transactions: [billing_transaction],
        credit_card: credit_card)

      component = described_class.new(policy:, billing_transaction:)

      expect(component.card_details).to eq "************3456"
    end

    it "returns nil if card is not present" do
      billing_transaction = build(:billing_transaction, due_date: Date.current)
      policy = build(:policy,
        recurring_payment_notice_doc_url: "http://example.com",
        billing_transactions: [billing_transaction],
        credit_card: nil)

      component = described_class.new(policy:, billing_transaction:)

      expect(component.card_details).to be_nil
    end
  end
end
