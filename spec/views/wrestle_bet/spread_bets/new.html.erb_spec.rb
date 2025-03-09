require 'rails_helper'

RSpec.describe "wrestle_bet/spread_bets/new", type: :view do
  before(:each) do
    assign(:wrestle_bet_spread_bet, WrestleBet::SpreadBet.new(
      match_id: FactoryBot.create(:wrestle_bet_match).id,
      user: FactoryBot.create(:user),
      wager: "away"
    ))
  end

  it "renders new wrestle_bet_spread_bet form" do
    render

    assert_select "form[action=?][method=?]", wrestle_bet_spread_bets_path, "post" do

      assert_select "input[name=?]", "wrestle_bet_spread_bet[match_id]"

      assert_select "input[name=?]", "wrestle_bet_spread_bet[wager]"
    end
  end
end
