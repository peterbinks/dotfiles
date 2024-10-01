require "rails_helper"
require "text_helpers/contexts"

RSpec.describe Portal::Documents::PolicyDocumentsComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "#current_documents" do
    it "gets the correct count and list of current documents" do
      primary_person = build(:person, id: 1)
      co_person = build(:person, id: 2)
      primary_applicant = build(:applicant, primary: true, person_id: primary_person.id)
      co_applicant = build(:applicant, co_applicant: true, person_id: co_person.id)

      documents = [
        build(:document, label: "privacy_notice", show_in_portal: true, person: primary_person, term: 1),
        build(:document, label: "privacy_notice", show_in_portal: true, person: primary_person, term: 0),
        build(:document, label: "electronic_delivery_consent", show_in_portal: true, person: primary_person),
        build(:document, label: "mortgagee_invoice", show_in_portal: true, person: primary_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: co_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: co_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: primary_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: primary_person),
        build(:document, label: "policy_packet", show_in_portal: true, person: primary_person, term: 0),
        build(:document, label: "policy_renewal_packet", show_in_portal: true, person: primary_person, term: 1),
        build(:document, label: "declaration_page", show_in_portal: true, person: primary_person, updated_at: 30.minutes.ago, term: 1),
        build(:document, label: "declaration_page", show_in_portal: true, person: primary_person, updated_at: 5.minutes.ago, term: 0),
        build(:document, label: "privacy_notice", show_in_portal: false, person: co_person),
        build(:document, label: "electronic_delivery_consent", show_in_portal: false, person: co_person),
        build(:document, label: "surplus_lines_acknowledgement_form", show_in_portal: true, person: primary_person),
        build(:document, label: "surplus_lines_acknowledgement_form", show_in_portal: true, person: co_person),
        build(:document, label: "notice_of_hurricane_deductible", show_in_portal: true, person: co_person),
        build(:document, label: "notice_of_cancellation", show_in_portal: true, person: primary_person),
        build(:document, label: "notice_of_non_payment_cancellation", show_in_portal: true, person: primary_person),
        build(:document, label: "notice_of_future_cancellation", show_in_portal: true, person: primary_person),
        build(:document, label: "notice_of_non_renewal", show_in_portal: true, person: primary_person),
        build(:document, label: "cancellation_request", show_in_portal: true, person: primary_person),
        build(:document, label: "proof_for_cancellation", show_in_portal: true, person: primary_person),
        build(:document, label: "no_longer_pending_cancellation_action_required", show_in_portal: true, person: primary_person),
        build(:document, label: "no_longer_pending_cancellation_issue_resolved", show_in_portal: true, person: primary_person),
        build(:document, label: "statement_of_no_loss", show_in_portal: true, person: co_person),
        build(:document, label: "statement_of_no_loss", show_in_portal: true, person: primary_person),
        build(:document, label: "statement_of_no_loss", show_in_portal: true, person: primary_person)
      ]

      policy = build(:policy, documents: documents, applicants: [primary_applicant, co_applicant], current_term: 1)

      subject = described_class.new(policy:)

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

      expect(subject.current_documents.map(&:label)).to match_array(expected)
      expect(subject.send(:primary_documents).map(&:label)).to match_array(primary_docs)
      expect(subject.send(:secondary_documents).map(&:label)).to match_array(secondary_docs)
      expect(subject.send(:tertiary_documents).map(&:label)).to match_array(tertiary_documents)
    end
  end

  context "#outdated_documents" do
    it "gets the correct count and list of outdated documents" do
      primary_person = build(:person, id: 1)
      co_person = build(:person, id: 2)
      primary_applicant = build(:applicant, primary: true, person_id: primary_person.id)
      co_applicant = build(:applicant, co_applicant: true, person_id: co_person.id)

      documents = [
        build(:document, label: "privacy_notice", show_in_portal: true, person: primary_person, term: 1),
        build(:document, label: "privacy_notice", show_in_portal: true, person: primary_person, term: 0),
        build(:document, label: "electronic_delivery_consent", show_in_portal: true, person: primary_person),
        build(:document, label: "mortgagee_invoice", show_in_portal: true, person: primary_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: co_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: co_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: primary_person),
        build(:document, label: "subscriber_agreement", show_in_portal: true, person: primary_person),
        build(:document, label: "policy_packet", show_in_portal: true, person: primary_person, term: 0),
        build(:document, label: "policy_renewal_packet", show_in_portal: true, person: primary_person, term: 1),
        build(:document, label: "declaration_page", show_in_portal: true, person: primary_person, updated_at: 30.minutes.ago, term: 1),
        build(:document, label: "declaration_page", show_in_portal: true, person: primary_person, updated_at: 5.minutes.ago, term: 0),
        build(:document, label: "privacy_notice", show_in_portal: false, person: co_person),
        build(:document, label: "electronic_delivery_consent", show_in_portal: false, person: co_person),
        build(:document, label: "statement_of_no_loss", show_in_portal: true, person: co_person),
        build(:document, label: "statement_of_no_loss", show_in_portal: true, person: primary_person),
        build(:document, label: "statement_of_no_loss", show_in_portal: true, person: primary_person)
      ]

      policy = build(:policy, documents: documents, applicants: [primary_applicant, co_applicant], current_term: 1)

      subject = described_class.new(policy:)

      outdated_documents = subject.outdated_documents
      expected = %w[privacy_notice policy_packet declaration_page statement_of_no_loss]
      expect(outdated_documents.count).to eq(4)
      expect(outdated_documents.map(&:label)).to include(*expected)
    end
  end
end
