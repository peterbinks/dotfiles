require "rails_helper"

RSpec.describe Portal::Policies::AddNewCreditCardComponent, :js, type: :component do
  let(:merchant_account) { "merchant_account_value" }
  let(:product) { double("Product", merchant_account: merchant_account) }
  let(:recurring_payment_notice_doc) { [double("Document", expiring_url: "http://example.com/eft_authorization")] }
  let(:policy) { double("Policy", recurring_payment_notice_doc: recurring_payment_notice_doc, product: product, full_policy_number: "KIN-HO-FL-248835486") }
  let(:auth_net_client) { instance_double(AuthNet::Client, login_id: "login_id_value", generate_public_client_key: "client_key") }
  let(:component) { described_class.new(policy: policy) }

  before do
    allow(AuthNet::Client).to receive(:new).with(account: merchant_account).and_return(auth_net_client)
    render_inline(component)
  end

  context "when initialized" do
    it "renders the form with the correct elements" do
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
