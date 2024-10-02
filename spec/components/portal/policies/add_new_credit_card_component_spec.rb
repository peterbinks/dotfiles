require "rails_helper"

RSpec.describe Portal::Policies::AddNewCreditCardComponent, :js, type: :component do
  context "when initialized" do
    it "renders the form with the correct elements" do
      client = double("client", login_id: "login_id", generate_public_client_key: "generate_public_client_key")
      policy = build(:policy,
        recurring_payment_notice_doc_url: "http://example.com",
        auth_net_client: client)

      component = described_class.new(policy:)

      render_inline(component)

      expect(page).to have_selector("kin-dialog#newCreditCardModal")
      expect(rendered_content).to have_css("[data-rspec= 'add-credit-card-header']")
      expect(rendered_content).to have_css("[data-rspec='first_name']")
      expect(rendered_content).to have_css("[data-rspec='last_name']")
      expect(rendered_content).to have_css("[data-rspec='number']")
      expect(rendered_content).to have_css("[data-rspec='expiration']")
      expect(rendered_content).to have_css("[data-rspec='cvv']")
      expect(rendered_content).to have_css("[data-rspec='zip']")
      expect(rendered_content).to have_css("[data-rspec= 'electronics-transfer-link']")
    end
  end
end
