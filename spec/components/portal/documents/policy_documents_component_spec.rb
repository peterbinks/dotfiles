require "rails_helper"
require "text_helpers/contexts"

RSpec.describe Portal::Documents::PolicyDocumentsComponent, domain: :policy_administration, type: :component, feature: :portal do
  let(:policy) { create(:bright_policy, :with_primary_insured_with_signed_documents, term: 1) }
  subject { described_class.new(policy: policy) }

  context "#current_documents" do
    it "gets the correct count and list of current documents" do
      create(:co_applicant, policy: policy)
      create(:document, label: "privacy_notice", show_in_portal: true, documentable: policy, person: policy.primary_insured, term: 1)
      create(:document, label: "privacy_notice", show_in_portal: true, documentable: policy, person: policy.primary_insured, term: 0)
      create(:document, label: "electronic_delivery_consent", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "mortgagee_invoice", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "policy_packet", show_in_portal: true, documentable: policy, person: policy.primary_insured, term: 0)
      create(:document, label: "policy_renewal_packet", show_in_portal: true, documentable: nil, person: policy.primary_insured, term: 1)
      create(:document, label: "declaration_page", show_in_portal: true, documentable: policy, person: policy.primary_insured, updated_at: 30.minutes.ago, term: 1)
      create(:document, label: "declaration_page", show_in_portal: true, documentable: policy, person: policy.primary_insured, updated_at: 5.minutes.ago, term: 0)
      create(:document, label: "privacy_notice", show_in_portal: false, documentable: policy, person: policy.co_applicant)
      create(:document, label: "electronic_delivery_consent", show_in_portal: false, documentable: policy, person: policy.co_applicant)
      create(:document, label: "surplus_lines_acknowledgement_form", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "surplus_lines_acknowledgement_form", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "notice_of_hurricane_deductible", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "notice_of_cancellation", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "notice_of_non_payment_cancellation", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "notice_of_future_cancellation", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "notice_of_non_renewal", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "cancellation_request", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "proof_for_cancellation", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "no_longer_pending_cancellation_action_required", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "no_longer_pending_cancellation_issue_resolved", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "statement_of_no_loss", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "statement_of_no_loss", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "statement_of_no_loss", show_in_portal: true, documentable: policy, person: policy.primary_insured)

      primary_docs = %w[
        notice_of_cancellation
        notice_of_future_cancellation
        notice_of_non_payment_cancellation
        notice_of_non_renewal
        cancellation_request
        proof_for_cancellation
        no_longer_pending_cancellation_action_required
        no_longer_pending_cancellation_issue_resolved
        policy_renewal_packet
        declaration_page
        mortgagee_invoice
        notice_of_hurricane_deductible
      ]
      secondary_docs = %w[
        privacy_notice
        electronic_delivery_consent
      ]
      tertiary_documents = (["subscriber_agreement"] * 4) +
        (["surplus_lines_acknowledgement_form"] * 2) +
        (["statement_of_no_loss"] * 2)

      expected = primary_docs + secondary_docs + tertiary_documents

      expect(subject.current_documents.pluck(:label)).to match_array(expected)
      expect(subject.send(:primary_documents).pluck(:label)).to match_array(primary_docs)
      expect(subject.send(:secondary_documents).pluck(:label)).to match_array(secondary_docs)
      expect(subject.send(:tertiary_documents).pluck(:label)).to match_array(tertiary_documents)
    end
  end

  context "#outdated_documents" do
    it "gets the correct count and list of outdated documents" do
      create(:co_applicant, policy: policy)
      create(:document, label: "privacy_notice", show_in_portal: true, documentable: policy, person: policy.primary_insured, term: 1)
      create(:document, label: "privacy_notice", show_in_portal: true, documentable: policy, person: policy.primary_insured, term: 0)
      create(:document, label: "electronic_delivery_consent", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "mortgagee_invoice", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "subscriber_agreement", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "policy_packet", show_in_portal: true, documentable: policy, person: policy.primary_insured, term: 0)
      create(:document, label: "policy_renewal_packet", show_in_portal: true, documentable: nil, person: policy.primary_insured, term: 1)
      create(:document, label: "declaration_page", show_in_portal: true, documentable: policy, person: policy.primary_insured, updated_at: 30.minutes.ago, term: 1)
      create(:document, label: "declaration_page", show_in_portal: true, documentable: policy, person: policy.primary_insured, updated_at: 5.minutes.ago, term: 0)
      create(:document, label: "privacy_notice", show_in_portal: false, documentable: policy, person: policy.co_applicant)
      create(:document, label: "electronic_delivery_consent", show_in_portal: false, documentable: policy, person: policy.co_applicant)
      create(:document, label: "statement_of_no_loss", show_in_portal: true, documentable: policy, person: policy.co_applicant)
      create(:document, label: "statement_of_no_loss", show_in_portal: true, documentable: policy, person: policy.primary_insured)
      create(:document, label: "statement_of_no_loss", show_in_portal: true, documentable: policy, person: policy.primary_insured)

      outdated_documents = subject.outdated_documents
      expected = %w[privacy_notice policy_packet declaration_page statement_of_no_loss]
      expect(outdated_documents.count).to eq(4)
      expect(outdated_documents.pluck(:label)).to include(*expected)
    end
  end
end
