require "rails_helper"

RSpec.describe Portal::Billing::FailedTransactionAlertComponent, domain: :policy_administration, type: :component, feature: :portal do
  describe "integration tests" do
    context "when initialized" do
      context "when the policy is bound" do
        it "renders the form with the correct elements" do
          credit_card = double("credit_card", last_4: 1111)
          address = double("address", full_street_address: "123 Main St")
          policy = double("bright_policy", in_quote_post_effective_date?: false, credit_card: credit_card, address: address, full_policy_number: "123456")
          transaction = double("billing_transaction", bright_policy: policy, installment_number: 1, amount_cents: 100)

          component = described_class.new(transaction: transaction)

          render_inline(component)
          expect(rendered_content).to have_css("[data-rspec= 'failed-transaction-alert']")
          expect(rendered_content).to have_text("A payment on your credit card ending in 1111 was rejected.")
          expect(rendered_content).to have_text("We were unable to charge $1.00 for your 1st payment at 123 Main St.")
          expect(rendered_content).to have_text("Please update your payment method as soon as possible to keep your policy active.")
        end
      end

      context "when the policy is not bound" do
        it "renders the form with the correct elements" do
          credit_card = double("credit_card", last_4: 1111)
          address = double("address", full_street_address: "123 Main St")
          policy = double("bright_policy", in_quote_post_effective_date?: true, credit_card: credit_card, address: address, full_policy_number: "123456")
          transaction = double("billing_transaction", bright_policy: policy, installment_number: 1, amount_cents: 100)

          component = described_class.new(transaction: transaction)

          render_inline(component)
          expect(rendered_content).to have_css("[data-rspec= 'failed-transaction-alert']")
          expect(rendered_content).to have_text("A payment on your credit card ending in 1111 was rejected.")
          expect(rendered_content).to have_text("We were unable to charge $1.00 for your 1st payment at 123 Main St.")
          expect(rendered_content).to have_text("Please call customer service at (855) 216-7674.")
        end
      end
    end
  end

  describe "unit tests" do
    describe "#render?" do
      it "returns true" do
        credit_card = double("credit_card")
        policy = double("policy", credit_card: credit_card)
        transaction = double("transaction", bright_policy: policy)

        component = described_class.new(transaction: transaction)

        expect(component.render?).to be true
      end
    end

    describe "#policy_number" do
      it "returns the policy number" do
        credit_card = double("credit_card")
        policy = double("policy", credit_card: credit_card, full_policy_number: "123456")
        transaction = double("transaction", bright_policy: policy)

        component = described_class.new(transaction: transaction)

        expect(component.policy_number).to eq("123456")
      end
    end

    describe "#amount" do
      it "returns the transaction amount" do
        credit_card = double("credit_card")
        policy = double("policy", credit_card: credit_card)
        transaction = double("transaction", bright_policy: policy, amount_cents: 100)

        component = described_class.new(transaction: transaction)

        expect(component.amount).to eq("$1.00")
      end
    end

    describe "#payment_type" do
      context "transation is an installment payment" do
        it "returns the installment number" do
          credit_card = double("credit_card")
          policy = double("policy", credit_card: credit_card)
          transaction = double("transaction", bright_policy: policy, installment_number: 1, endorsement_request_id: nil)

          component = described_class.new(transaction: transaction)

          expect(component.payment_type).to eq("1st")
        end
      end

      context "transation is an Endorsement payment" do
        it "returns 'Endorsement'" do
          credit_card = double("credit_card")
          policy = double("policy", credit_card: credit_card)
          transaction = double("transaction", bright_policy: policy, installment_number: nil, endorsement_request_id: 1)

          component = described_class.new(transaction: transaction)

          expect(component.payment_type).to eq("Endorsement")
        end
      end
    end

    describe "#address" do
      it "returns the address associated with the transaction" do
        address = double("address", full_street_address: "123 Main St")
        credit_card = double("credit_card")
        policy = double("policy", credit_card: credit_card, address: address)
        transaction = double("transaction", bright_policy: policy)

        component = described_class.new(transaction: transaction)

        expect(component.address).to eq("123 Main St")
      end
    end

    describe "#last_4" do
      it "returns the last 4 digits associated with the credit_card" do
        credit_card = double("credit_card", last_4: "1234")
        policy = double("policy", credit_card: credit_card)
        transaction = double("transaction", bright_policy: policy)

        component = described_class.new(transaction: transaction)

        expect(component.last_4).to eq("1234")
      end
    end

    describe "#show_update_link?" do
      context "when the current path does not end with 'edit'" do
        it "returns true" do
          credit_card = double("credit_card", last_4: "1234")
          policy = double("policy", credit_card: credit_card)
          transaction = double("transaction", bright_policy: policy)

          component = described_class.new(transaction: transaction)

          allow(component).to receive(:request).and_return(double("request", path: "/some/path"))

          expect(component.show_update_link?).to be true
        end
      end

      context "when the current path ends with 'edit'" do
        it "returns false" do
          credit_card = double("credit_card", last_4: "1234")
          policy = double("policy", credit_card: credit_card)
          transaction = double("transaction", bright_policy: policy)

          component = described_class.new(transaction: transaction)

          allow(component).to receive(:request).and_return(double("request", path: "/some/path/edit"))

          expect(component.show_update_link?).to be false
        end
      end
    end
  end
end
