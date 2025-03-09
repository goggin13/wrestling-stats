require 'rails_helper'

RSpec.describe "wrestle_bet/matches/show", type: :view do
  before(:each) do
    @match = assign(:wrestle_bet_match, WrestleBet::Match.create!(
      weight: 149,
      started: false,
      home_wrestler_id: FactoryBot.create(:wrestle_bet_wrestler).id,
      away_wrestler_id: FactoryBot.create(:wrestle_bet_wrestler).id,
      home_score: 17,
      away_score: 18,
      tournament_id: FactoryBot.create(:wrestle_bet_tournament).id
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/149 lbs/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/#{@match.home_wrestler.name}/)
    expect(rendered).to match(/#{@match.away_wrestler.name}/)
    expect(rendered).to match(/17/)
    expect(rendered).to match(/18/)
    expect(rendered).to match(/#{@match.tournament.name}/)
  end
end
