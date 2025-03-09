require "rails_helper"

feature "WrestleBet Betslip page" do
  before do
    @user = FactoryBot.create(:user)
    @home_wrestler = FactoryBot.create(:wrestle_bet_wrestler, name: "Gable Steveson")
    @away_wrestler = FactoryBot.create(:wrestle_bet_wrestler, name: "Greg Kerkvliet")
    @match = FactoryBot.create(:wrestle_bet_match,
      weight: 285,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
      spread: 6.5,
    )
    @tournament = @match.tournament
    @betslip_path = "/wrestle_bet/tournaments/#{@tournament.id}/betslip"
  end

  scenario "redirects with an error message if no user is logged in" do
    visit @betslip_path
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  scenario "it lets you bet on the home wrestler" do
    sign_in(@user)
    visit @betslip_path
    expect(page).to have_content("Your Betslip")

    expect do
      click_button "Bet on Gable Steveson"
    end.to change(WrestleBet::SpreadBet, :count).by (1)

    bet = WrestleBet::SpreadBet.last!
    expect(bet.user_id).to eq(@user.id)
    expect(bet.match_id).to eq(@match.id)
    expect(bet.wager).to eq("home")

    expect(page).to have_content("Bet on Gable Steveson placed")
    expect(page).to have_content("Your Betslip")
  end

  scenario "it lets you bet on the away wrestler" do
    sign_in(@user)
    visit @betslip_path
    expect(page).to have_content("Your Betslip")

    expect do
      click_button "Bet on Greg Kerkvliet"
    end.to change(WrestleBet::SpreadBet, :count).by (1)

    bet = WrestleBet::SpreadBet.last!
    expect(bet.user_id).to eq(@user.id)
    expect(bet.match_id).to eq(@match.id)
    expect(bet.wager).to eq("away")

    expect(page).to have_content("Bet on Greg Kerkvliet placed")
    expect(page).to have_content("Your Betslip")
  end
end
