require "rails_helper"

RSpec.describe Portal::Policy, type: :model do
  describe "#primary_insured" do
    it "returns the primary applicant" do
      primary_applicant = build(:applicant, primary: true)
      co_applicant = build(:applicant, co_applicant: true)
      policy = build(:policy, applicants: [primary_applicant, co_applicant])

      primary_applicant = policy.applicants.find_by(primary: true)
      expect(policy.primary_insured).to eq primary_applicant
    end
  end

  describe "#co_applicant" do
    it "returns the co-applicant" do
      primary_applicant = build(:applicant, primary: true)
      co_applicant = build(:applicant, co_applicant: true)
      policy = build(:policy, applicants: [primary_applicant, co_applicant])

      co_applicant = policy.applicants.find_by(co_applicant: true)
      expect(policy.co_applicant).to eq co_applicant
    end
  end

  describe "#policy_status" do
    it "returns the policy status as a StringInquirer" do
      policy = build(:policy, trait: :bound)

      expect(policy.policy_status).to be_a(ActiveSupport::StringInquirer)
      expect(policy.policy_status.to_s).to eq policy.status
    end
  end

  describe "#active?" do
    it "returns true if the policy is a quote and has a signed active application" do
      policy = build(:policy, trait: :quote, has_signed_active_application: true)
      expect(policy.active?).to be true
    end

    it "returns true if the policy is bound" do
      policy = build(:policy, trait: :bound)
      expect(policy.active?).to be true
    end

    it "returns true if the policy is in_force" do
      policy = build(:policy, trait: :in_force)
      expect(policy.active?).to be true
    end
  end

  describe "#quote_and_signed?" do
    it "returns true if the policy is a quote and has a signed active application" do
      policy = build(:policy, trait: :quote, has_signed_active_application: true)
      expect(policy.quote_and_signed?).to be true
    end
  end

  describe "#billing_corrections_needed?" do
    it "returns true if billing corrections are needed" do
      policy = build(:policy, billing_corrections_needed: true)
      expect(policy.billing_corrections_needed?).to eq policy.billing_corrections_needed
    end
  end

  describe "#term" do
    it "returns the term with the given number" do
      term_0 = build(:term, number: 0)
      term_1 = build(:term, number: 1)
      policy = build(:policy, terms: [term_0, term_1])
      expect(policy.term(number: 1)).to eq term_1
    end
  end

  describe "#effective_date" do
    it "returns the effective date of the first term" do
      term_0 = build(:term, number: 0, effective_date: Date.yesterday)
      policy = build(:policy, terms: [term_0])
      expect(policy.effective_date).to eq policy.term(number: 0)&.effective_date
    end
  end

  describe "#term_effective_date" do
    it "returns the effective date of the current term" do
      term_0 = build(:term, number: 0, effective_date: Date.new(2023, 1, 1))
      term_1 = build(:term, number: 0, effective_date: Date.new(2024, 1, 1))
      policy = build(:policy, terms: [term_0, term_1], current_term: 1)

      expect(policy.term_effective_date).to eq policy.term(number: policy.current_term)&.effective_date
    end
  end

  describe "#term_end_date" do
    it "returns the end date of the current term" do
      term_0 = build(:term, number: 0, end_date_date: Date.new(2024, 1, 1))
      term_1 = build(:term, number: 0, end_date_date: Date.new(2025, 1, 1))
      policy = build(:policy, terms: [term_0, term_1], current_term: 1)

      expect(policy.term_end_date).to eq policy.term(number: policy.current_term)&.end_date
    end
  end

  describe "#in_quote_post_effective_date?" do
    it "returns true if the policy is a quote and the effective date is in the past" do
      term_0 = build(:term, number: 0, effective_date: Date.new(2024, 1, 1))
      policy = build(:policy, terms: [term_0], current_term: 0, status: "quote")

      expect(policy.in_quote_post_effective_date?).to be true
    end
  end

  describe "associations" do
    context "has_one" do
      it "property" do
        property = build(:property)
        policy = build(:policy, property: property)

        expect(policy.property).to be_a(Portal::Property)
      end
    end
  end
end
