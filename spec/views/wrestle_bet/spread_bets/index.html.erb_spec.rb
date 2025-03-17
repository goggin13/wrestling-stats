require 'rails_helper'

RSpec.describe "wrestle_bet/spread_bets/index", type: :view do
  before(:each) do
    assign(:wrestle_bet_spread_bets, [
      FactoryBot.create(:wrestle_bet_spread_bet,
        wager: "home"
      ),
      FactoryBot.create(:wrestle_bet_spread_bet,
        wager: "away"
      )
    ])
  end

  it "renders a list of wrestle_bet/spread_bets" do
    render
    expect(rendered).to match(/home/)
    expect(rendered).to match(/away/)
  end
end
