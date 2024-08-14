require "rails_helper"

describe "Policy Page", :js, domain: :policy_administration do
  context "Layout" do
    it "displays the breadcrumbs" do
      person = build(:person)
      primary_insured = build(:primary_insured, contact: person)
      sign_in person.user
      policy = create(:bright_policy, :bound, policy_contacts: [primary_insured])

      visit portal_policy_path(id: policy.full_policy_number)

      expect(page).to have_css(".breadcrumbs")
    end

    context "when the payment type is card and there is a failed transaction scheduled after the effective date" do
      it "displays the failed transaction alerts" do
        allow(AuthNet::Client).to receive(:new) { double("AuthClient", generate_public_client_key: "waka", login_id: "dori") }
        person = build(:person)
        credit_card = create(:credit_card, :with_auth_net_data)
        primary_insured = build(:primary_insured, contact: person, payment_method: credit_card)
        sign_in person.user
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured], payment_type: :card)
        create(:billing_transaction, :with_payment_rejected, bright_policy: policy, amount: 999, accounting_premium: 999, updated_at: (policy.effective_date + 1.day))

        visit portal_policy_path(id: policy.full_policy_number)

        expect(page).to have_css('[data-rspec="failed-transaction-alert"]')
      end
    end

    it "displays the Policy Summary card" do
      person = build(:person)
      primary_insured = build(:primary_insured, contact: person)
      sign_in person.user
      policy = create(:bright_policy, :bound, policy_contacts: [primary_insured])

      visit portal_policy_path(id: policy.full_policy_number)

      expect(page).to have_css('[data-rspec="policy-summary-detail"]')
    end

    it "displays the tabs list" do
      person = build(:person)
      primary_insured = build(:primary_insured, contact: person)
      sign_in person.user
      policy = create(:bright_policy, :bound, policy_contacts: [primary_insured])

      visit portal_policy_path(id: policy.full_policy_number)

      expect(page).to have_css("kin-tabs")

      %w[
        documents-tab
        payments-tab
      ].each do |tab|
        expect(page).to have_css("[data-rspec='#{tab}']")
      end
    end
  end
end
