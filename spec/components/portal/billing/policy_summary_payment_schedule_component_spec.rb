require "rails_helper"

RSpec.describe Portal::Billing::PolicySummaryPaymentScheduleComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "billing corrections are needed" do
    it "does not render the block" do
      transaction = build(:billing_transaction, payment_type: "scheduled", status: "upcoming")
      policy = build(:policy, billing_transactions: [transaction], billing_corrections_needed: true)

      subject = described_class.new(policy:)

      render_inline(subject)

      expect(rendered_content).to_not have_css("[data-rspec='payment-schedule-block']")
    end
  end

  context "billing corrections are not needed" do
    it "renders the block" do
      transaction = build(:billing_transaction, payment_type: "scheduled", status: "upcoming")
      policy = build(:policy, billing_transactions: [transaction], billing_corrections_needed: false)

      subject = described_class.new(policy:)

      render_inline(subject)

      expect(rendered_content).to have_css("[data-rspec='payment-schedule-block']")
    end
  end

  describe "#disable_text_color" do
    context "when the transaction is approved" do
      it "returns 'c-neutral-600'" do
        transaction = build(:billing_transaction, status: "approved")
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        expect(subject.disable_text_color(transaction)).to eq("c-neutral-600")
      end
    end

    context "when the transaction is not approved" do
      it "returns an empty string" do
        transaction = build(:billing_transaction, status: "upcoming")
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        expect(subject.disable_text_color(transaction)).to eq("")
      end
    end
  end

  context "#show_payment_button?" do
    context "when manual payments are enabled, it is the next transaction, it is an unsettled cash payment, there is no endorsement in progress, and there is no credit card on the policy" do
      it "returns true" do
        transaction = build(:billing_transaction)
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:is_next_upcoming_transaction_installment?).with(transaction).and_return(true)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(true)

        expect(subject.show_payment_button?(transaction)).to be true
      end
    end

    context "when manual payments are disabled" do
      it "returns false" do
        transaction = build(:billing_transaction)
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(false)

        expect(subject.show_payment_button?(transaction)).to be false
      end
    end

    context "when the transaction is not the next transaction and no endorsements" do
      it "returns false" do
        transaction = build(:billing_transaction)
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:is_next_upcoming_transaction_installment?).with(transaction).and_return(false)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(false)

        expect(subject.show_payment_button?(transaction)).to be false
      end
    end

    context "when the transaction is not the next transaction and there is an endorsement in progress" do
      it "returns true" do
        transaction = build(:billing_transaction)
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:upcoming_endorsement_transactions).and_return([transaction])
        allow(subject).to receive(:is_next_upcoming_transaction_installment?).with(transaction).and_return(false)

        expect(subject.show_payment_button?(transaction)).to be true
      end
    end

    context "when it is not an unsettled cash payment" do
      it "returns false" do
        transaction = build(:billing_transaction)
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(false)
        allow(subject).to receive(:unsettled_cash_payment?).with(transaction).and_return(false)
        allow(subject).to receive(:is_next_upcoming_transaction?).with(transaction).and_return(true)
        allow(subject).to receive(:endorsement_request_in_progress?).and_return(false)

        expect(subject.show_payment_button?(transaction)).to be false
      end
    end

    context "when there is an endorsement in progress" do
      it "returns false" do
        transaction = build(:billing_transaction)
        policy = build(:policy, billing_transactions: [transaction])

        subject = described_class.new(policy:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(false)
        allow(subject).to receive(:unsettled_cash_payment?).with(transaction).and_return(true)
        allow(subject).to receive(:is_next_upcoming_transaction?).with(transaction).and_return(true)
        allow(subject).to receive(:endorsement_request_in_progress?).and_return(true)

        expect(subject.show_payment_button?(transaction)).to be false
      end
    end
  end
end
