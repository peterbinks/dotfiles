require "rails_helper"

RSpec.describe Portal do
  it "has a version number" do
    expect(Portal::VERSION).not_to be_nil
  end

  it "loads the engine" do
    expect(defined?(Portal::Engine)).to eq("constant")
  end
end
