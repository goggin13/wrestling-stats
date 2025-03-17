require 'rails_helper'

RSpec.describe "wrestle_bet/matches/new", type: :view do
  before(:each) do
    assign(:wrestle_bet_match, WrestleBet::Match.new(
      weight: 1,
      started: false,
      home_wrestler_id: 1,
      away_wrestler_id: 1,
      home_score: 1,
      away_score: 1,
      tournament_id: 1
    ))
  end

  it "renders new wrestle_bet_match form" do
    render

    assert_select "form[action=?][method=?]", wrestle_bet_matches_path, "post" do

      assert_select "input[name=?]", "wrestle_bet_match[weight]"

      assert_select "input[name=?]", "wrestle_bet_match[started]"

      assert_select "input[name=?]", "wrestle_bet_match[home_wrestler_id]"

      assert_select "input[name=?]", "wrestle_bet_match[away_wrestler_id]"

      assert_select "input[name=?]", "wrestle_bet_match[home_score]"

      assert_select "input[name=?]", "wrestle_bet_match[away_score]"

      assert_select "input[name=?]", "wrestle_bet_match[tournament_id]"
    end
  end
end
