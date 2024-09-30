require "rails_helper"

RSpec.describe Portal::Address do
  describe "#initialize" do
    context "when address is nil" do
      it "does not initialize the object" do
        portal_address = Portal::Address.new({})

        expect(portal_address.id).to be_nil
        expect(portal_address.full_street_address).to be_nil
        expect(portal_address.full_city_state).to be_nil
      end
    end

    context "when address is present" do
      it "initializes the object with given attributes" do
        address = build(:address)

        expect(address).to be_a(Portal::Address)
      end
    end
  end

  describe "#to_s" do
    it "returns the full street address" do
      address = build(:address)

      expect(address.to_s).to eq address.full_street_address
    end
  end
end
