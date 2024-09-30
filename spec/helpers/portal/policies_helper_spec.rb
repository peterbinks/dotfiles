require "rails_helper"

describe Portal::PoliciesHelper, domain: :policy_administration do
  # let(:policy) { create(:bright_policy) }

  # before do
  #   allow(Document).to receive(:required_for) { policy }.and_return([:proof_of_prior_insurance])
  #   policy.documents.create(label: "proof_of_prior_insurance", documentable: policy)
  # end

  describe "#formatted_review_status" do
    it "returns a translation for a status" do
      review_status = "not_reviewed"
      document = build(:document, label: "proof_of_prior_insurance", review_status: review_status)
      policy = build(:policy, fix_type: :bound, documents: [document])
      
      expect(I18n).to receive(:translate)

      formatted_review_status(review_status)
    end
  end

  describe "#documents_all_pending_review?" do
    it "returns true if all documents are pending review" do
      document = build(:document,
        label: "proof_of_prior_insurance",
        review_status: "not_reviewed",
        needs_verification: true,
      )
      policy = build(:policy, fix_type: :bound, documents: [document])

      allow(policy).to receive(:uploaded_required_documents) { [document] }
      expect(documents_all_pending_review?(policy.uploaded_required_documents)).to be true
    end

    it "returns false if there are no documents" do
      policy = build(:policy, fix_type: :bound, documents: Portal::Document.none)
      allow(policy).to receive(:uploaded_required_documents) { Portal::Document.none }
      expect(documents_all_pending_review?(policy.uploaded_required_documents)).to be false
    end

    it "returns false if not all documents are pending review" do
      document = build(:document,
        label: "proof_of_prior_insurance",
        review_status: "accepted",
        needs_verification: false,
      )
      policy = build(:policy, fix_type: :bound, documents: [document])

      expect(documents_all_pending_review?(policy.uploaded_required_documents)).to be false
    end
  end

  describe "#missing_required_documents?" do
    it "returns true if there are no uploaded required documents" do
      policy = build(:policy,
        fix_type: :bound,
        documents: [],
        uploaded_required_documents: Portal::Document.none,
        required_documents_labels: ["proof_of_prior_insurance"],
      )

      expect(missing_required_documents?(policy)).to be true
    end

    it "returns true if there are required documents that are rejected" do
      document = build(:document, label: "proof_of_prior_insurance", review_status: "rejected")
      policy = build(:policy,
        fix_type: :bound,
        documents: [document],
        uploaded_required_documents: [document],
        required_documents_labels: ["proof_of_prior_insurance"],
      )

      expect(missing_required_documents?(policy)).to be true
    end

    it "returns false if all uploaded documents have been accepted" do
      document = build(:document, label: "proof_of_prior_insurance", review_status: "accepted")
      policy = build(:policy,
        fix_type: :bound,
        documents: [document],
        uploaded_required_documents: [document],
        required_documents_labels: ["proof_of_prior_insurance"],
      )

      expect(missing_required_documents?(policy)).to be false
    end
  end

  context "css classes" do
    let(:label) { "policy_packet" }

    describe "#doc_type_class" do
      it "returns a class for a given label if applicable" do
        expect(doc_type_class(label)).to_not eq label
        expect(doc_type_class(label)).to be_a_kind_of(String)
      end

      it "returns nil if there is no applicable class" do
        expect(doc_type_class("nope")).to be_nil
      end
    end

    describe "#doc_type_aria_label" do
      it "returns an aria label for a given label if applicable" do
        expect(doc_type_aria_label(label)).to_not eq label
        expect(doc_type_aria_label(label)).to be_a_kind_of(String)
      end

      it "returns nil if there is no applicable class" do
        expect(doc_type_class("nope")).to be_nil
      end
    end
  end
end
