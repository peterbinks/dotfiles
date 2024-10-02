require "rails_helper"

RSpec.describe Portal::Policies::DisplayPremiumComponent, type: :component do
  it "renders the formatted premium amount" do
    render_inline(described_class.new(amount: 1234.56))

    expect(rendered_content).to have_css("span.sr-only", text: "$1,234.56")
  end

  it "renders the formatted premium amount when whole number" do
    render_inline(described_class.new(amount: 1234))

    expect(rendered_content).to have_css("span.sr-only", text: "$1,234.00")
  end

  it "raises error when premium amount is not a number" do
    expect {
      render_inline(described_class.new(amount: "hello world"))
    }.to raise_error(ArgumentError)
  end
end
