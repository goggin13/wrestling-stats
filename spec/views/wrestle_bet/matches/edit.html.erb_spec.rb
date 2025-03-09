require 'rails_helper'

RSpec.describe "wrestle_bet/matches/edit", type: :view do
  before(:each) do
    @wrestle_bet_match = assign(:wrestle_bet_match, WrestleBet::Match.create!(
      weight: 1,
      started: false,
      home_wrestler_id: FactoryBot.create(:wrestle_bet_wrestler).id,
      away_wrestler_id: FactoryBot.create(:wrestle_bet_wrestler).id,
      home_score: 1,
      away_score: 1,
      tournament_id: FactoryBot.create(:wrestle_bet_tournament).id
    ))
  end

  it "renders the edit wrestle_bet_match form" do
    render

    assert_select "form[action=?][method=?]", wrestle_bet_match_path(@wrestle_bet_match), "post" do

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
