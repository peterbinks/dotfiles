require "rails_helper"

describe Portal::PoliciesController, domain: :policy_administration, type: :controller, feature: :portal do
  context "As primary applicant" do
    let(:policy) { create(:bright_policy, :with_primary_insured_with_signed_documents) }
    let(:policy_of_user_two) { create(:bright_policy, :with_primary_insured_with_signed_documents) }

    before do
      sign_in policy.primary_insured.user
    end

    describe "#show" do
      it "renders the show template when only one applicant" do
        get :show, params: {id: policy.policy_number}

        expect(response).to render_template(:show)
      end

      it "renders the show template when there's a co-applicant" do
        policy.policy_contacts << create(:co_applicant)
        get :show, params: {id: policy.policy_number}

        expect(response).to render_template(:show)
      end

      it "shows both subscriber aggreements and co-applicant documents" do
        create(:co_applicant, policy: policy)
        policy.applicants.reload
        documents = [
          create(:document, label: "privacy_notice", show_in_portal: true, documentable: policy, person: policy.primary_insured),
          create(:document, label: "electronic_delivery_consent", show_in_portal: true, documentable: policy, person: policy.primary_insured),
          create(:document, label: "other", show_in_portal: true, documentable: policy, person: policy.primary_insured),
          create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: nil, person: policy.co_applicant),
          create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: nil, person: policy.primary_insured)
        ]
        create(:document, label: "privacy_notice", show_in_portal: false, documentable: policy, person: policy.co_applicant)
        create(:document, label: "electronic_delivery_consent", show_in_portal: false, documentable: policy, person: policy.co_applicant)
        get :show, params: {id: policy.policy_number}

        policy_documents_component = Portal::Documents::PolicyDocumentsComponent.new(policy:)
        expect(policy_documents_component.current_documents.count).to eq(documents.count)
      end

      it "does not show a policy to an unauthorized user" do
        get :show, params: {id: policy_of_user_two.full_policy_number}

        expect(response.code).to eq("404")
      end
    end
  end

  context "As co-applicant" do
    let(:policy) { create(:bright_policy, :with_primary_and_co_applicant_with_signatures) }

    before do
      sign_in policy.co_applicant.user
    end

    describe "#show" do
      it "renders the show template" do
        get :show, params: {id: policy.policy_number}

        expect(response).to render_template(:show)
      end

      it "shows both subscriber agreements and primary applicant documents without duplicates" do
        documents = [
          create(:document, label: "privacy_notice", show_in_portal: true, documentable: policy, person: policy.co_applicant),
          create(:document, label: "electronic_delivery_consent", show_in_portal: true, documentable: policy, person: policy.co_applicant),
          create(:document, label: "other", show_in_portal: true, documentable: nil, person: policy.co_applicant),
          create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: nil, person: policy.primary_insured),
          create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: nil, person: policy.co_applicant),
        ]
        create(:document, label: "privacy_notice", show_in_portal: false, documentable: policy, person: policy.primary_insured)
        create(:document, label: "electronic_delivery_consent", show_in_portal: false, documentable: policy, person: policy.primary_insured)
        get :show, params: {id: policy.policy_number}
        policy_documents_component = Portal::Documents::PolicyDocumentsComponent.new(policy:)
        expect(policy_documents_component.current_documents.count).to eq(documents.count)
      end
    end
  end
end
