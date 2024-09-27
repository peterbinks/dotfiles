require "rails_helper"

RSpec.describe Portal::Policy, type: :model do
  let(:policy) { build(:policy, associations: [:all]) }

  describe "#primary_insured" do
    it "returns the primary applicant" do
      primary_applicant = policy.applicants.find(&:primary)
      expect(policy.primary_insured).to eq primary_applicant
    end
  end

  describe "#co_applicant" do
    it "returns the co-applicant" do
      co_applicant = policy.applicants.find(&:co_applicant)
      expect(policy.co_applicant).to eq co_applicant
    end
  end

  describe "#policy_status" do
    it "returns the policy status as a StringInquirer" do
      expect(policy.policy_status).to be_a(ActiveSupport::StringInquirer)
      expect(policy.policy_status.to_s).to eq policy.status
    end
  end

  describe "#active?" do
    it "returns true if the policy is active" do
      allow(policy).to receive(:quote_and_signed?).and_return(true)
      expect(policy.active?).to be true
    end
  end

  describe "#quote_and_signed?" do
    it "returns true if the policy is a quote and has a signed active application" do
      allow(policy).to receive(:quote?).and_return(true)
      allow(policy).to receive(:has_signed_active_application?).and_return(true)
      expect(policy.quote_and_signed?).to be true
    end
  end

  describe "#billing_corrections_needed?" do
    it "returns true if billing corrections are needed" do
      expect(policy.billing_corrections_needed?).to eq policy.billing_corrections_needed
    end
  end

  describe "#term_groups" do
    it "returns a hash of terms grouped by their number" do
      term_groups = policy.terms.map { |term| [term.number, term] }.to_h
      expect(policy.term_groups).to eq term_groups
    end
  end

  describe "#effective_date" do
    it "returns the effective date of the first term" do
      expect(policy.effective_date).to eq policy.term_groups[0]&.effective_date
    end
  end

  describe "#term_effective_date" do
    it "returns the effective date of the current term" do
      expect(policy.term_effective_date).to eq policy.term_groups[policy.current_term]&.effective_date
    end
  end

  describe "#term_end_date" do
    it "returns the end date of the current term" do
      expect(policy.term_end_date).to eq policy.term_groups[policy.current_term]&.end_date
    end
  end

  describe "#in_quote_post_effective_date?" do
    it "returns true if the policy is a quote and the effective date is in the past" do
      allow(policy).to receive(:quote?).and_return(true)
      allow(policy).to receive(:effective_date).and_return(Date.yesterday)
      expect(policy.in_quote_post_effective_date?).to be true
    end
  end

  describe "associations" do
    context "has_one" do
      it "property" do
        policy = build(:policy, associations: [:property])

        expect(policy.property).to be_a(Portal::Property)
      end
    end
  end
end
