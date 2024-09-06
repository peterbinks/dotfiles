require "rails_helper"

RSpec.describe Portal::Billing::PaymentMethod::CardComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "payment type is card" do
    it "renders payment type block" do
      policy = double(
        "BrightPolicy",
        policy_number: "fake_policy_number",
        payment_type_card?: true,
        credit_card: build_stubbed(:credit_card, :with_auth_net_data)
      )

      render_inline(described_class.new(policy:))

      expect(rendered_content).to have_css("[data-rspec='card-payment-block']", text: "Payment Method - Credit Card")
    end

    it "shows the last four digits of credit card" do
      credit_card = build_stubbed(:credit_card, :with_auth_net_data)
      policy = double(
        "BrightPolicy",
        policy_number: "fake_policy_number",
        payment_type_card?: true,
        credit_card: credit_card
      )

      render_inline(described_class.new(policy:))

      expected_last_four = credit_card.last_4[-4..]
      expect(rendered_content).to have_css("[data-rspec='card-payment-last-four-digits']", text: expected_last_four)
    end

    it "shows the expiration of credit card" do
      credit_card = build_stubbed(:credit_card, :with_auth_net_data)
      policy = double(
        "BrightPolicy",
        policy_number: "fake_policy_number",
        payment_type_card?: true,
        credit_card: credit_card
      )

      render_inline(described_class.new(policy:))

      expected_expiration_month = %r{\A#{credit_card.exp_month.to_s.rjust(2, "0")}\z}
      expected_expiration_year = credit_card.exp_year

      expect(rendered_content).to have_css("[data-rspec='card-expiration-month']", text: expected_expiration_month)
      expect(rendered_content).to have_css("[data-rspec='card-expiration-year']", text: expected_expiration_year)
    end
  end

  context "payment type is not card" do
    it "does not render payment type block" do
      policy = double(
        "BrightPolicy",
        policy_number: "fake_policy_number",
        payment_type_card?: false,
        credit_card: nil
      )

      expect(described_class.new(policy:).render?).to be false
    end
  end
end
