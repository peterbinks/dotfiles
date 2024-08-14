require "rails_helper"

describe "Policy Documents tab", :js, domain: :policy_administration do
  context "Required documents section" do
    context "no required documents present" do
      it "does not display the card" do
        person = build(:person)
        primary_insured = build(:primary_insured, contact: person)
        sign_in person.user
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured])

        visit portal_policy_path(id: policy.full_policy_number)
        find("kin-tab", text: "Documents").click

        expect(page).to_not have_css('[data-rspec="required-documents-block"]')
      end
    end

    context "documents present" do
      it "displays the documents on the policy" do
        person = build(:person)
        primary_insured = build(:primary_insured, contact: person)
        sign_in person.user
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured])

        create(:blocker, :required_document, bright_policy: policy)

        visit portal_policy_path(id: policy.full_policy_number)
        find("kin-tab", text: "Documents").click

        expect(page).to have_css('[data-rspec="required-documents-block"]')
      end
    end
  end

  context "Policy documents section" do
    context "no documents present" do
      it "displays that there are no documents on the policy" do
        person = build(:person)
        primary_insured = build(:primary_insured, contact: person)
        sign_in person.user
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured])

        visit portal_policy_path(id: policy.full_policy_number)
        find("kin-tab", text: "Documents").click

        expect(page).to have_css('[data-rspec="policy-documents-block"]')
        expect(page).to have_css('[data-rspec="policy-documents-no-documents-message"]')
      end
    end

    context "documents present" do
      it "displays the documents on the policy" do
        person = build(:person)
        primary_insured = build(:primary_insured, contact: person)
        sign_in person.user
        policy = create(:bright_policy, :bound, policy_contacts: [primary_insured])
        create(:document, label: "policy_packet", show_in_portal: true, documentable: policy, person: policy.primary_insured, term: 0)

        visit portal_policy_path(id: policy.full_policy_number)
        find("kin-tab", text: "Documents").click

        expect(page).to have_css('[data-rspec="policy-documents-block"]')
        expect(page).to have_content("Policy Packet")
      end
    end
  end
end
