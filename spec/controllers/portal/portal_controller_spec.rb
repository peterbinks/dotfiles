require "rails_helper"

# TODO: Controller tests don't work with the current setup. 
# Authentication needs to be moved completely to dot-com
xdescribe Portal::PortalController, domain: :policy_administration, type: :controller do
  let(:user) { create(:user) }

  controller do
    before_action :authenticate_user!

    def index
      head :ok
    end
  end

  before do
    sign_in user
  end

  it "redirects to the account page if the user does not have a person" do
    get :index
    expect(response).to redirect_to edit_portal_account_path
  end

  context "user has a person" do
    let(:policy) { create(:bright_policy, :with_primary_insured) }
    let(:person) { policy.people.first }
    let(:user) { person.user }
    let!(:policy_application) { create(:policy_application, policy: policy) }

    it "works" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
