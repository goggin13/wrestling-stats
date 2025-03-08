require 'rails_helper'

RSpec.describe "wrestle_bet/wrestlers/index", type: :view do
  before(:each) do
    assign(:wrestle_bet_wrestlers, [
      WrestleBet::Wrestler.create!(
        name: "Name",
        college: nil
      ),
      WrestleBet::Wrestler.create!(
        name: "Name",
        college: nil
      )
    ])
  end

  it "renders a list of wrestle_bet/wrestlers" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
