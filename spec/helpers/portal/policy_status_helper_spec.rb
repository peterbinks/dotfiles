require "rails_helper"

describe Portal::PolicyStatusHelper, domain: :policy_administration do
  describe "#portal_policy_status_text" do
    it "returns the first result of #portal_policy_status_text_and_style" do
      policy = double
      expect(self).to receive(:portal_policy_status_text_and_style).with(policy) { ["first", "second"] }
      expect(portal_policy_status_text(policy)).to eq "first"
    end
  end

  describe "#portal_policy_status_style" do
    it "returns the second result of #portal_policy_status_text_and_style" do
      policy = double
      expect(self).to receive(:portal_policy_status_text_and_style).with(policy) { ["first", "second"] }
      expect(portal_policy_status_style(policy)).to eq "second"
    end
  end

  describe "#portal_policy_status_text_and_style" do
    context "for a quote with a signed application" do
      it 'returns "Signed" text and "primary" style' do
        policy_application = double(:policy_application, signed?: true)
        policy = double(
          :bright_policy,
          quote?: true,
          active_application: policy_application,
          pending_cancellation: false
        )

        expect(portal_policy_status_text_and_style(policy)).to eq ["Signed", "primary"]
      end
    end

    context "for a policy that is pending cancellation" do
      it 'returns "Pending cancellation" text and "warning" style' do
        policy = double(
          :bright_policy,
          active_application: nil,
          pending_cancellation: true,
          status: "bound"
        )

        expect(portal_policy_status_text_and_style(policy)).to eq ["Pending cancellation", "warning"]
      end
    end

    context "for a bound policy" do
      it 'returns "Active on <effective_date>" text and "primary" style' do
        effective_date = 1.month.from_now

        policy = double(
          :bright_policy,
          active_application: nil,
          pending_cancellation: false,
          status: "bound",
          effective_date:
        )

        expect(portal_policy_status_text_and_style(policy)).to eq ["Active on #{effective_date.to_s(:kin_date)}", "primary"]
      end
    end

    context "for an in-force policy" do
      it 'returns "Active" text and "secondary" style' do
        policy = double(
          :bright_policy,
          active_application: nil,
          pending_cancellation: false,
          status: "in_force"
        )

        expect(portal_policy_status_text_and_style(policy)).to eq ["Active", "secondary"]
      end
    end

    context "for a policy that is cancelled, non-renewed, or expired" do
      it 'returns "Inactive" text and "info" style' do
        statuses = %w[
          cancelled
          non_renewed
          expired
        ]

        statuses.each do |status|
          policy = double(
            :bright_policy,
            active_application: nil,
            pending_cancellation: false,
            status:
          )

          expect(portal_policy_status_text_and_style(policy)).to eq ["Inactive", "info"]
        end
      end
    end
  end
end
