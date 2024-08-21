require "rails_helper"

RSpec.describe Portal::Billing::PolicySummaryPaymentScheduleComponent, domain: :policy_administration, type: :component, feature: :portal do
  context "billing corrections are needed" do
    it "does not render the block" do
      policy = double("bright_policy")
      billing_transactions = double("billing_transactions")
      subject = described_class.new(policy:, billing_transactions:)

      allow(subject).to receive(:billing_corrections_needed?).and_return(true)

      render_inline(subject)

      expect(rendered_content).to_not have_css("[data-rspec='payment-schedule-block']")
    end
  end

  context "billing corrections are not needed" do
    it "renders the block" do
      policy = double("bright_policy")
      billing_transactions = double("billing_transactions", each: true)
      subject = described_class.new(policy:, billing_transactions:)

      allow(subject).to receive(:billing_corrections_needed?).and_return(false)

      render_inline(subject)

      expect(rendered_content).to have_css("[data-rspec='payment-schedule-block']")
    end
  end

  describe "#disable_text_color" do
    context "when the transaction is approved" do
      it "returns 'c-neutral-600'" do
        transaction = double("transaction", status_approved?: true)
        policy = double("bright_policy")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        expect(subject.disable_text_color(transaction)).to eq("c-neutral-600")
      end
    end

    context "when the transaction is not approved" do
      it "returns an empty string" do
        transaction = double("transaction", status_approved?: false)
        policy = double("bright_policy")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        expect(subject.disable_text_color(transaction)).to eq("")
      end
    end
  end

  context "#show_payment_button?" do
    context "when manual payments are enabled, it is the next transaction, it is an unsettled cash payment, there is no endorsement in progress, and there is no credit card on the policy" do
      it "returns true" do
        policy = double("bright_policy")
        transaction = double("billing_transaction")

        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:is_next_upcoming_transaction_installment?).with(transaction).and_return(true)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(true)

        expect(subject.show_payment_button?(transaction)).to be true
      end
    end

    context "when manual payments are disabled" do
      it "returns false" do
        policy = double("bright_policy")
        transaction = double("billing_transaction")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(false)

        expect(subject.show_payment_button?(transaction)).to be false
      end
    end

    context "when the transaction is not the next transaction and no endorsements" do
      it "returns false" do
        policy = double("bright_policy")
        transaction = double("billing_transaction")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:is_next_upcoming_transaction_installment?).with(transaction).and_return(false)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(false)

        expect(subject.show_payment_button?(transaction)).to be false
      end

      context "integration tests" do
        it "true for the first transaction if no transactions are paid" do
          policy = double("bright_policy")
          first_transaction = create(:billing_transaction, bright_policy: policy, due_date: 1.day.from_now)
          second_transaction = create(:billing_transaction, bright_policy: policy, due_date: 2.days.from_now)
          billing_transactions = double("billing_transactions")
          subject = described_class.new(policy:, billing_transactions:)

          allow(subject).to receive(:manual_payments_enabled?).and_return(true)
          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(first_transaction).and_return(false)

          expect(subject.show_payment_button?(first_transaction)).to be true

          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(second_transaction).and_return(false)

          expect(subject.show_payment_button?(second_transaction)).to be false
        end

        it "returns true for the first transaction even if it is a shortpayment" do
          policy = build(:bright_policy)
          first_transaction = create(:billing_transaction, :shortpayment, bright_policy: policy, due_date: 1.day.from_now)
          second_transaction = create(:billing_transaction, bright_policy: policy, due_date: 2.days.from_now)
          billing_transactions = double("billing_transactions")
          subject = described_class.new(policy:, billing_transactions:)

          allow(subject).to receive(:manual_payments_enabled?).and_return(true)

          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(first_transaction).and_return(false)
          expect(subject.show_payment_button?(first_transaction)).to be true
          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(second_transaction).and_return(false)
          expect(subject.show_payment_button?(second_transaction)).to be false
        end

        it "true for the first transaction if the first transaction is rejected" do
          policy = build(:bright_policy)
          first_transaction = create(:billing_transaction, :with_payment_rejected, bright_policy: policy, due_date: 1.day.from_now)
          second_transaction = create(:billing_transaction, bright_policy: policy, due_date: 2.days.from_now)
          billing_transactions = double("billing_transactions")
          subject = described_class.new(policy:, billing_transactions:)

          allow(subject).to receive(:manual_payments_enabled?).and_return(true)

          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(first_transaction).and_return(false)
          expect(subject.show_payment_button?(first_transaction)).to be true
          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(second_transaction).and_return(false)
          expect(subject.show_payment_button?(second_transaction)).to be false
        end

        it "returns false for the paid transactions and true for the first unpaid transaction" do
          policy = build(:bright_policy)
          first_transaction = create(:billing_transaction, bright_policy: policy, due_date: 1.day.from_now)
          first_transaction.status_approved!
          second_transaction = create(:billing_transaction, bright_policy: policy, due_date: 2.days.from_now)
          billing_transactions = double("billing_transactions")
          subject = described_class.new(policy:, billing_transactions:)

          allow(subject).to receive(:manual_payments_enabled?).and_return(true)

          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(first_transaction).and_return(false)
          expect(subject.show_payment_button?(first_transaction)).to be false
          allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(second_transaction).and_return(false)
          expect(subject.show_payment_button?(second_transaction)).to be true
        end
      end
    end

    context "when the transaction is not the next transaction and there is an endorsement in progress" do
      it "returns true" do
        policy = double("bright_policy")
        transaction = double("billing_transaction")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:upcoming_endorsement_transactions).and_return([transaction])
        allow(subject).to receive(:is_next_upcoming_transaction_installment?).with(transaction).and_return(false)

        expect(subject.show_payment_button?(transaction)).to be true
      end
    end

    context "when it is not an unsettled cash payment" do
      it "returns false" do
        policy = double("bright_policy")
        transaction = double("billing_transaction")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

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
        policy = double("bright_policy")
        transaction = double("billing_transaction")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        allow(subject).to receive(:manual_payments_enabled?).and_return(true)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(false)
        allow(subject).to receive(:unsettled_cash_payment?).with(transaction).and_return(true)
        allow(subject).to receive(:is_next_upcoming_transaction?).with(transaction).and_return(true)
        allow(subject).to receive(:endorsement_request_in_progress?).and_return(true)

        expect(subject.show_payment_button?(transaction)).to be false
      end
    end

    context "when there is a credit card on the policy" do
      it "returns true" do
        policy = double("bright_policy")
        transaction = double("billing_transaction")

        allow(policy).to receive(:credit_card).and_return("1234567890")
        billing_transactions = double("billing_transactions")
        subject = described_class.new(policy:, billing_transactions:)

        allow(subject).to receive(:is_next_upcoming_transaction_installment?).with(transaction).and_return(true)
        allow(subject).to receive(:is_any_upcoming_transaction_endorsement?).with(transaction).and_return(true)

        expect(subject.show_payment_button?(transaction)).to be true
      end
    end
  end
end
