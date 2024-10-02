require "rails_helper"

RSpec.describe Portal::Policies::PolicySummaryComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "on my policies page" do
    it "does not render policy change button" do
      applicant = build(:applicant, primary: true)
      document = build(:document, label: "declaration_page", show_in_portal: true)
      address = build(:address)
      term = build(:term)
      coverage = build(:coverage)
      product = build(:product)
      policy = build(:policy,
        applicants: [applicant],
        documents: [document],
        terms: [term],
        coverage: coverage,
        product: product,
        address: address)

      render_inline(described_class.new(policy:))

      expect(rendered_content).not_to have_css('a[href="https://support.kin.com/contact/submit-request-BynGK5BkF"]', text: "Request Policy Change")
    end

    it "renders the formatted premium amount" do
      applicant = build(:applicant, primary: true)
      document = build(:document, label: "declaration_page", show_in_portal: true)
      address = build(:address)
      term = build(:term)
      coverage = build(:coverage)
      product = build(:product)
      policy = build(:policy,
        applicants: [applicant],
        documents: [document],
        terms: [term],
        coverage: coverage,
        product: product,
        address: address,
        premium: 3675)

      render_inline(described_class.new(policy:))

      expect(rendered_content).to have_css("[data-rspec='premium_quote']", text: "$3,675")
    end

    it "renders superscript cents for formatted premium amount" do
      applicant = build(:applicant, primary: true)
      document = build(:document, label: "declaration_page", show_in_portal: true)
      address = build(:address)
      term = build(:term)
      coverage = build(:coverage)
      product = build(:product)
      policy = build(:policy,
        applicants: [applicant],
        documents: [document],
        terms: [term],
        coverage: coverage,
        product: product,
        address: address,
        premium: 3675)

      render_inline(described_class.new(policy:))

      expect(rendered_content).to have_css("[data-rspec='premium_quote'] span", text: "00")
    end

    it "renders cancelled policies" do
      applicant = build(:applicant, primary: true)
      document = build(:document, label: "declaration_page", show_in_portal: true)
      address = build(:address)
      term = build(:term)
      coverage = build(:coverage)
      product = build(:product)
      cancelled_policy = build(:policy,
        applicants: [applicant],
        documents: [document],
        terms: [term],
        coverage: coverage,
        product: product,
        address: address,
        status: "cancelled")

      render_inline(described_class.new(policy: cancelled_policy))

      expect(rendered_content).to have_css("[data-rspec='quote_status']", text: "Inactive")
    end
  end

  context "when the policy is about to expire" do
    context "and the renewal status is renew" do
      it "renders new renewal premium text" do
        applicant = build(:applicant, primary: true)
        address = build(:address)
        document0 = build(:document, label: "declaration_page", show_in_portal: true, term: 0, updated_at: 5.minutes.ago)
        document1 = build(:document, label: "declaration_page", show_in_portal: true, term: 1, updated_at: 30.minutes.ago)
        term0 = build(:term, number: 0, effective_date: Date.current - 700.days, end_date: Date.current - 350.days)
        term1 = build(:term, number: 1, effective_date: Date.current - 350.days, end_date: Date.current + 15.days)
        coverage = build(:coverage)
        product = build(:product)
        renewal_policy = build(:policy, premium: 1727)
        policy = build(:policy,
          applicants: [applicant],
          documents: [document0, document1],
          terms: [term0, term1],
          coverage: coverage,
          product: product,
          address: address,
          renewal_policy: renewal_policy,
          premium: 3675)

        render_inline(described_class.new(policy: policy))

        expect(rendered_content).to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
      end

      it "renders the formatted premium amount" do
        applicant = build(:applicant, primary: true)
        address = build(:address)
        document0 = build(:document, label: "declaration_page", show_in_portal: true, term: 0, updated_at: 5.minutes.ago)
        document1 = build(:document, label: "declaration_page", show_in_portal: true, term: 1, updated_at: 30.minutes.ago)
        term0 = build(:term, number: 0, effective_date: Date.current - 700.days, end_date: Date.current - 350.days)
        term1 = build(:term, number: 1, effective_date: Date.current - 350.days, end_date: Date.current + 15.days)
        coverage = build(:coverage)
        product = build(:product)
        renewal_policy = build(:policy, premium: 1727)
        policy = build(:policy,
          applicants: [applicant],
          documents: [document0, document1],
          terms: [term0, term1],
          coverage: coverage,
          product: product,
          address: address,
          renewal_policy: renewal_policy)

        render_inline(described_class.new(policy: policy))

        expect(rendered_content).to have_css("[data-rspec='upcoming_amount']", text: "$1,727")
      end

      it "renders superscript cents for formatted premium amount" do
        applicant = build(:applicant, primary: true)
        address = build(:address)
        document0 = build(:document, label: "declaration_page", show_in_portal: true, term: 0, updated_at: 5.minutes.ago)
        document1 = build(:document, label: "declaration_page", show_in_portal: true, term: 1, updated_at: 30.minutes.ago)
        term0 = build(:term, number: 0, effective_date: Date.current - 700.days, end_date: Date.current - 350.days)
        term1 = build(:term, number: 1, effective_date: Date.current - 350.days, end_date: Date.current + 15.days)
        coverage = build(:coverage)
        product = build(:product)
        renewal_policy = build(:policy, premium: 1727)
        policy = build(:policy,
          applicants: [applicant],
          documents: [document0, document1],
          terms: [term0, term1],
          coverage: coverage,
          product: product,
          address: address,
          renewal_policy: renewal_policy)

        render_inline(described_class.new(policy: policy))

        expect(rendered_content).to have_css("[data-rspec='upcoming_amount'] span", text: "00")
      end
    end

    context "and the renewal status is do_not_renew" do
      it "does not render new renewal premium text" do
        applicant = build(:applicant, primary: true)
        address = build(:address)
        document0 = build(:document, label: "declaration_page", show_in_portal: true, term: 0, updated_at: 5.minutes.ago)
        document1 = build(:document, label: "declaration_page", show_in_portal: true, term: 1, updated_at: 30.minutes.ago)
        term0 = build(:term, number: 0, effective_date: Date.current - 700.days, end_date: Date.current - 350.days)
        term1 = build(:term, number: 1, effective_date: Date.current - 350.days, end_date: Date.current + 15.days)
        coverage = build(:coverage)
        product = build(:product)
        policy = build(:policy,
          applicants: [applicant],
          documents: [document0, document1],
          terms: [term0, term1],
          coverage: coverage,
          product: product,
          address: address,
          renewal_status: "do_not_renew")

        render_inline(described_class.new(policy: policy))

        expect(rendered_content).not_to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
      end
    end
  end

  context "when the policy is not about to expire" do
    it "does not render new renewal premium text" do
      applicant = build(:applicant, primary: true)
      address = build(:address)
      document = build(:document, label: "declaration_page", show_in_portal: true, term: 0, updated_at: 5.minutes.ago)
      term = build(:term, number: 0, effective_date: Date.current, end_date: Date.current + 1.year)
      coverage = build(:coverage)
      product = build(:product)
      policy = build(:policy,
        applicants: [applicant],
        documents: [document],
        terms: [term],
        coverage: coverage,
        product: product,
        address: address)

      render_inline(described_class.new(policy: policy))

      expect(rendered_content).not_to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
    end
  end

  context "when the policy is non_renewed" do
    context "and the renewal status is do_not_renew" do
      it "renders term 0 premium text" do
        applicant = build(:applicant, primary: true)
        address = build(:address)
        document0 = build(:document, label: "declaration_page", show_in_portal: true, term: 0, updated_at: 5.minutes.ago)
        document1 = build(:document, label: "declaration_page", show_in_portal: true, term: 1, updated_at: 5.minutes.ago)
        term0 = build(:term, number: 0, effective_date: Date.current - 370.days, end_date: Date.current - 5.days)
        term1 = build(:term, number: 1, effective_date: Date.current - 5.days, end_date: Date.current + 360.days)
        coverage = build(:coverage)
        product = build(:product)
        renewal_policy = build(:policy, premium: 1727)
        policy = build(:policy,
          applicants: [applicant],
          documents: [document0, document1],
          terms: [term0, term1],
          coverage: coverage,
          product: product,
          address: address,
          renewal_policy: renewal_policy,
          renewal_status: "do_not_renew",
          premium: 3675)

        render_inline(described_class.new(policy: policy))

        expect(rendered_content).to have_css("[data-rspec='premium_quote']", text: "$3,675")
      end

      it "does not render the upcoming premium text" do
        applicant = build(:applicant, primary: true)
        address = build(:address)
        document0 = build(:document, label: "declaration_page", show_in_portal: true, term: 0, updated_at: 5.minutes.ago)
        document1 = build(:document, label: "declaration_page", show_in_portal: true, term: 1, updated_at: 5.minutes.ago)
        term0 = build(:term, number: 0, effective_date: Date.current - 370.days, end_date: Date.current - 5.days)
        term1 = build(:term, number: 1, effective_date: Date.current - 5.days, end_date: Date.current + 360.days)
        coverage = build(:coverage)
        product = build(:product)
        renewal_policy = build(:policy, premium: 1727)
        policy = build(:policy,
          applicants: [applicant],
          documents: [document0, document1],
          terms: [term0, term1],
          coverage: coverage,
          product: product,
          address: address,
          renewal_policy: renewal_policy,
          status: "non_renewed",
          renewal_status: "do_not_renew",
          premium: 3675)

        render_inline(described_class.new(policy: policy))

        expect(rendered_content).not_to have_css("[data-rspec='upcoming_annual_premium_block']", text: "Upcoming Annual Premium")
      end
    end
  end
end
