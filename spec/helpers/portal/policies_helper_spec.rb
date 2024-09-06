require "rails_helper"

describe Portal::PoliciesHelper, domain: :policy_administration do
  let(:policy) { create(:bright_policy) }

  before do
    allow(Document).to receive(:required_for) { policy }.and_return([:proof_of_prior_insurance])
    policy.documents.create(label: "proof_of_prior_insurance", documentable: policy)
  end

  describe "#formatted_review_status" do
    let(:review_status) { policy.documents.first.review_status }

    it "returns a translation for a status" do
      expect(I18n).to receive(:translate)

      formatted_review_status(review_status)
    end
  end

  describe "#documents_all_pending_review?" do
    let(:document) { policy.documents.first }

    it "returns true if all documents are pending review" do
      allow(document).to receive(:needs_verification?).and_return(true)
      document.review_status = "not_reviewed"
      allow(policy).to receive(:uploaded_required_documents) { [document] }
      expect(documents_all_pending_review?(policy.uploaded_required_documents)).to be true
    end

    it "returns false if there are no documents" do
      allow(policy).to receive(:uploaded_required_documents) { Document.none }
      expect(documents_all_pending_review?(policy.uploaded_required_documents)).to be false
    end

    it "returns false if not all documents are pending review" do
      document.review_status = "accepted"
      allow(document).to receive(:needs_verification?).and_return(false)
      allow(policy).to receive(:uploaded_required_documents) { [document] }
      expect(documents_all_pending_review?(policy.uploaded_required_documents)).to be false
    end
  end

  describe "#missing_required_documents?" do
    let(:document) { create(:document, label: "proof_of_prior_insurance", documentable: policy) }

    it "returns true if there are no uploaded required documents" do
      allow(policy).to receive(:uploaded_required_documents) { Document.none }
      expect(missing_required_documents?(policy)).to be true
    end

    it "returns true if there are required documents that are not accepted" do
      allow(policy).to receive(:uploaded_required_documents) { Document.where(id: document.id) }

      policy.uploaded_required_documents.first.update(review_status: "rejected")

      expect(missing_required_documents?(policy)).to be true
    end

    it "returns false if all uploaded documents have been accepted" do
      allow(policy).to receive(:uploaded_required_documents) { Document.where(id: document.id) }

      policy.uploaded_required_documents.first.update(review_status: "accepted")

      expect(missing_required_documents?(policy)).to be false
    end

    it "returns false if there are only excluded customer facing documents" do
      excluded_document = build(:blocker, :required_document, bright_policy: policy, name: Document.const_get(:DOCUMENTS_NOT_DISPLAYED_IN_KSO).sample)

      policy.blockers << excluded_document

      allow(Document).to receive(:required_for).with(policy, exclude_customer_facing: true)

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
