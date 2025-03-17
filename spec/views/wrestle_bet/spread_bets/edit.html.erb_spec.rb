require 'rails_helper'

RSpec.describe "wrestle_bet/spread_bets/edit", type: :view do
  before(:each) do
    @wrestle_bet_spread_bet = FactoryBot.create(:wrestle_bet_spread_bet)
    assign(:wrestle_bet_spread_bet, @wrestle_bet_spread_bet)
  end

  it "renders the edit wrestle_bet_spread_bet form" do
    render

    assert_select "form[action=?][method=?]", wrestle_bet_spread_bet_path(@wrestle_bet_spread_bet), "post" do

      assert_select "input[name=?]", "wrestle_bet_spread_bet[match_id]"

      assert_select "input[name=?]", "wrestle_bet_spread_bet[wager]"
    end
  end
end
