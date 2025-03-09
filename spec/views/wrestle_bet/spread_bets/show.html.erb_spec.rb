require 'rails_helper'

RSpec.describe "wrestle_bet/spread_bets/show", type: :view do
  before(:each) do
    @wrestle_bet_spread_bet = FactoryBot.create(:wrestle_bet_spread_bet,
      wager: "away"
    )
    assign(:wrestle_bet_spread_bet, @wrestle_bet_spread_bet)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/away/)
  end
end
