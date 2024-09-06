require "rails_helper"

describe "Policy Payment tab", :js, domain: :policy_administration do
  context "Payment Method card" do
    context "payment type is 'escrow'" do
      it "does not display the payment type" do
        person = build(:person)
        primary_insured = build(:primary_insured, contact: person)
        sign_in person.user
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured], payment_type: "escrow")

        visit policy_path(id: policy.policy_number)
        find("kin-tab", text: "Payments").click

        expect(page).to_not have_css('[data-rspec="card-payment-block"]')
      end
    end

    context "payment type is 'card' and a credit card is present" do
      it "displays the payment type" do
        person = build(:person)
        credit_card = build(:credit_card, :with_auth_net_data)
        primary_insured = build(:primary_insured, contact: person, payment_method: credit_card)

        sign_in person.user
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured], payment_type: "card")

        visit policy_path(id: policy.policy_number)
        find("kin-tab", text: "Payments").click

        expect(page).to have_css('[data-rspec="card-payment-block"]')
      end
    end
  end

  context "Payment Schedule card" do
    context "When billing needs to be corrected on the policy" do
      it "does not display the card" do
        person = build(:person)
        primary_insured = build(:primary_insured, contact: person)
        sign_in person.user

        # billing transaction amount is $1102 while the frozen rating premium is $400
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured], frozen_rating: create(:rating, :output_override, total_premium: 400, total_fees: 0, premium_total: 400))
        create(:billing_transaction, due_date: Date.tomorrow, bright_policy: policy, amount: 1102, empa_fee: 2, accounting_premium: 1000, surplus: 100)

        visit policy_path(id: policy.policy_number)
        find("kin-tab", text: "Payments").click

        expect(page).to_not have_css('[data-rspec="payment-schedule-block"]')
        expect(page).to_not have_css('[data-rspec="payment-schedule-table"]')
      end
    end

    context "When there are transactions on the policy and billing is correct" do
      it "displays the payment schedule card" do
        allow(AuthNet::Client).to receive(:new) { double("AuthClient", generate_public_client_key: "waka", login_id: "dori") }

        person = build(:person)
        primary_insured = build(:primary_insured, contact: person)
        sign_in person.user

        # billing transaction amount is the same amount as the frozen rating premium
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured], frozen_rating: create(:rating, :output_override, total_premium: 1000, total_fees: 0, premium_total: 1000))
        create(:billing_transaction, due_date: Date.tomorrow, bright_policy: policy, amount: 1102, empa_fee: 2, accounting_premium: 1000, surplus: 100)

        visit policy_path(id: policy.policy_number)
        find("kin-tab", text: "Payments").click

        expect(page).to have_css('[data-rspec="payment-schedule-block"]')
        expect(page).to have_css('[data-rspec="payment-schedule-table"]')
      end
    end
  end
end
