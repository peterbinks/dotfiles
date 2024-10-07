require "rails_helper"

# TODO: Controller tests don't work with the current setup.
# Authentication needs to be moved completely to dot-com
xdescribe Portal::HomeController, type: :controller do
  routes { Portal::Engine.routes }

  before do
    controller.class.skip_before_action(:authenticate_user!)
  end

  describe "#index" do
    it "renders the index template" do
      get :index

      expect(response).to render_template(:index)
    end

    it "has a quote with a signed application" do
      policy = build(:policy, trait: :quote, has_signed_active_application: true)

      get :index
      expect(assigns(:policies)).to include(policy)
    end

    it "has a users bound policies" do
      bp = build(:policy, :bound, policy_contacts: [build(:primary_insured, contact: user.person)])
      active_application = create(:policy_application, signed_at: Time.current, bright_policy: bp)
      bp.policy_applications << active_application

      get :index
      expect(assigns(:policies)).to include(bp)
    end

    it "has a users in_force policies" do
      bp = build(:policy, :in_force, policy_contacts: [build(:primary_insured, contact: user.person)])
      active_application = create(:policy_application, signed_at: Time.current, bright_policy: bp)
      bp.policy_applications << active_application

      get :index
      expect(assigns(:policies)).to include(bp)
    end

    it "does not show duplicates if a cancelled policy also has a signed app" do
      bp = build(:policy, :quote, :with_primary_insured_with_signed_documents, documents: [create(:document, label: :policy_application, signed_at: Date.current)])
      bp2 = build(:policy, :cancelled, :with_primary_insured_with_signed_documents, documents: [create(:document, label: :policy_application, signed_at: Date.current)])
      active_application = create(:policy_application, signed_at: Time.current, bright_policy: bp)
      active_application2 = create(:policy_application, signed_at: Time.current, bright_policy: bp2)

      bp.applicants.primary.update(contact: user.person)
      bp.policy_applications << active_application
      bp2.applicants.primary.update(contact: user.person)
      bp2.policy_applications << active_application2

      get :index
      expect(assigns(:policies).length).to eq(2)
      expect(assigns(:policies)).to include(bp)
      expect(assigns(:policies)).to include(bp2)
    end

    it "does NOT have a resumable policy if signed application" do
      bp = build(:policy, status: :quote)
      create(:policy_application, bright_policy: bp, signed_at: Date.current)
      create(:customer_input_response, bright_policy: bp, person: user.person)
      bp.applicants.primary.update(contact: user.person)
      get :index
      expect(assigns(:resumable_policy)).to be_nil
    end

    it "does NOT have a resumable policy if bound_or_in_force" do
      bp = build(:policy, :bound)
      create(:customer_input_response, bright_policy: bp, person: user.person)
      bp.applicants.primary.update(contact: user.person)
      get :index
      expect(assigns(:resumable_policy)).to be_nil
    end

    it "does NOT have a resumable policy if no customer input filled out" do
      bp = build(:policy)

      bp.applicants.primary.update(contact: user.person)
      get :index
      expect(assigns(:resumable_policy)).to be_nil
    end

    it "does  have a resumable policy if  customer input filled out" do
      bp = build(:policy, :with_primary_insured, status: :quote)
      create(:customer_input_response, bright_policy: bp, person: user.person)
      bp.applicants.primary.update(contact: user.person)
      get :index
      expect(assigns(:resumable_policy)).not_to be_nil
    end

    context "#set_failed_card_transactions" do
      let!(:bp1) { build(:policy, :in_force, payment_type: "card", policy_contacts: [build(:primary_insured, contact: user.person)]) }
      let!(:bp2) { build(:policy, :in_force, payment_type: "escrow", policy_contacts: [build(:primary_insured, contact: user.person)]) }
      let!(:bp3) { build(:policy, :in_force, payment_type: "card", policy_contacts: [build(:primary_insured, contact: user.person)]) }
      let!(:bp4) { build(:policy, :in_force, payment_type: "card", policy_contacts: [build(:primary_insured, contact: user.person)]) }
      let(:old_card) { create(:credit_card, :with_auth_net_data, updated_at: 3.months.ago) }
      let(:good_card) { create(:credit_card, :with_auth_net_data) }

      it "returns an array of failed credit card transactions for the person" do
        create(:payment_method, bright_policy: bp1, credit_card: old_card)
        create(:payment_method, bright_policy: bp3, credit_card: good_card)
        create(:payment_method, bright_policy: bp4, credit_card: old_card)
        create(:policy_application, signed_at: Time.current, bright_policy: bp1)
        create(:policy_application, signed_at: Time.current, bright_policy: bp2)
        create(:policy_application, signed_at: Time.current, bright_policy: bp3)
        create(:policy_application, signed_at: Time.current, bright_policy: bp4)
        trans1 = create(:billing_transaction, bright_policy: bp1, status: :rejected)
        create(:billing_transaction, bright_policy: bp3, status: :upcoming)
        trans3 = create(:billing_transaction, bright_policy: bp4, status: :rejected)

        get :index
        expect(assigns(:failed_card_transactions)).to match_array([trans1, trans3])
      end
    end

    context "Slide Carousel" do
      context "when customer has not visited the portal and has a policy" do
        it "@slides gets set" do
          user = create(:user, person: create(:person))
          sign_in user
          build(:policy, :in_force, policy_contacts: [build(:primary_insured, contact: user.person)])

          get :index

          expect(assigns(:slides)).to be_present
        end
      end

      context "when customer has visited the portal" do
        it "@slides is not set" do
          user = create(:user, person: create(:person))
          sign_in user
          build(:policy, :in_force, policy_contacts: [build(:primary_insured, contact: user.person)])

          allow(user).to receive(:has_visited_customer_portal?).and_return(true)
          allow(controller).to receive(:current_user).and_return(user)

          get :index

          expect(assigns(:slides)).to be_nil
        end
      end

      context "when customer does not have a policy" do
        it "@slides is not set" do
          user = create(:user, person: create(:person))
          sign_in user

          get :index

          expect(assigns(:slides)).to be_nil
        end
      end
    end
  end

  describe "Policy Accordion" do
    context "if there are policies available" do
      it "@steps is set" do
        user = create(:user, person: create(:person))
        sign_in user
        build(:policy, :in_force, policy_contacts: [build(:primary_insured, contact: user.person)])

        allow(controller).to receive(:current_user).and_return(user)

        expect(PolicyAccordion::StepSerializer).to receive(:new).and_call_original

        get :index

        expect(assigns(:steps)).not_to be_nil
      end
    end

    context "if no policies available" do
      it "@steps is not set" do
        user = create(:user, person: create(:person))
        sign_in user

        allow(controller).to receive(:current_user).and_return(user)

        expect(PolicyAccordion::StepSerializer).not_to receive(:new).and_call_original

        get :index

        expect(assigns(:steps)).to be_nil
      end
    end
  end
end
