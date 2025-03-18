require "rails_helper"

feature "WrestleBet Scoreboard" do
  before do
    @user = FactoryBot.create(:user, :admin, handle: "test-user")
    @tournament = FactoryBot.create(:wrestle_bet_tournament, jesus: 2, exposure: 3, challenges: 4)
    @match_125 = FactoryBot.create(:wrestle_bet_match, tournament: @tournament,
       weight: 125, spread: -1.5, started: false)
    @match_285 = FactoryBot.create(:wrestle_bet_match, tournament: @tournament,
       weight: 285, spread: 1.5, started: false)

    @display_path = "/wrestle_bet/tournaments/#{@tournament.id}/display"
  end

  it "renders an empty scoreboard" do
    sign_in(@user)

    visit @display_path

    expect(page).to have_content("125")
    expect(page).to have_content("285")
    expect(page).to have_content("( 2 )")
    expect(page).to have_content("( 3 )")
    expect(page).to have_content("( 4 )")
  end

  it "renders a scoreboard with 1 winning spread bet" do
    sign_in(@user)

    FactoryBot.create(:wrestle_bet_spread_bet, user: @user, match: @match_125, wager: "home")
    @match_125.update(home_score: 10, away_score: 0)

    visit @display_path

    expect(page).to have_content("test-user")
    expect(page).to have_css(".spread_bet_result_1")
  end

  it "renders a scoreboard with 1 losing spread bet" do
    sign_in(@user)

    FactoryBot.create(:wrestle_bet_spread_bet, user: @user, match: @match_125, wager: "away")
    @match_125.update(home_score: 10, away_score: 0)

    visit @display_path

    expect(page).to have_content("test-user")
    expect(page).to_not have_css(".spread_bet_result_1")
  end
end
