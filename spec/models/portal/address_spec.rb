require "rails_helper"

RSpec.describe Portal::Address do
  let(:yaml) { file_fixture("addresses.yml") }
  let(:yaml_hash) { YAML.safe_load_file(yaml) }
  let(:address) { yaml_hash["one"].with_indifferent_access }

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
        portal_address = Portal::Address.new(address)
        expect(portal_address.id).to eq address[:id]
        expect(portal_address.full_street_address).to eq address[:full_street_address]
        expect(portal_address.full_city_state).to eq address[:full_city_state]
      end
    end
  end

  describe "#to_s" do
    it "returns the full street address" do
      portal_address = Portal::Address.new(address)
      expect(portal_address.to_s).to eq address[:full_street_address]
    end
  end
end
