require "rails_helper"

feature "WrestleBet Betslip page" do
  before do
    @user = FactoryBot.create(:user, email: "hello@example.com", handle: "hello")
    @home_wrestler = FactoryBot.create(:wrestle_bet_wrestler, name: "Gable Steveson")
    @away_wrestler = FactoryBot.create(:wrestle_bet_wrestler, name: "Greg Kerkvliet")
    @match = FactoryBot.create(:wrestle_bet_match,
      weight: 285,
      home_wrestler: @home_wrestler,
      away_wrestler: @away_wrestler,
      spread: -6.5,
    )

    @tournament = @match.tournament
    @betslip_path = "/wrestle_bet/tournaments/#{@tournament.id}/betslip"
  end

  scenario "redirects with an error message if no user is logged in" do
    visit @betslip_path
    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

  describe "prop bets" do
    it "allows you to place and update prop bets" do
      sign_in(@user)
      visit @betslip_path

      fill_in "wrestle_bet_prop_bet[jesus]", with: 1
      fill_in "wrestle_bet_prop_bet[exposure]", with: 2
      fill_in "wrestle_bet_prop_bet[challenges]", with: 3

      expect do
        click_button "Save Prop Bets"
      end.to change(WrestleBet::PropBet, :count).by(1)

      expect(page).to have_content("Prop bets updated")

      prop_bet = WrestleBet::PropBet.last!
      expect(prop_bet.user_id).to eq(@user.id)
      expect(prop_bet.tournament_id).to eq(@tournament.id)
      expect(prop_bet.jesus).to eq(1)
      expect(prop_bet.exposure).to eq(2)
      expect(prop_bet.challenges).to eq(3)

      fill_in "wrestle_bet_prop_bet[jesus]", with: 4
      fill_in "wrestle_bet_prop_bet[exposure]", with: 5
      fill_in "wrestle_bet_prop_bet[challenges]", with: 6

      expect do
        click_button "Save Prop Bets"
      end.to change(WrestleBet::PropBet, :count).by(0)

      expect(page).to have_content("Prop bets updated")

      prop_bet.reload
      expect(prop_bet.jesus).to eq(4)
      expect(prop_bet.exposure).to eq(5)
      expect(prop_bet.challenges).to eq(6)
    end

    it "does not allow a bet on a prop bet if the tournament has started" do
      sign_in(@user)
      visit @betslip_path
      @match.update(started: true)

      fill_in "wrestle_bet_prop_bet[jesus]", with: 1

      expect do
        click_button "Save Prop Bets"
      end.to change(WrestleBet::PropBet, :count).by(0)

      expect(page).to have_content("Tournament has already started")
    end
  end

  describe "spread bets" do
    it "redirects with an error message if that match has started" do
      sign_in(@user)
      visit @betslip_path

      @match.update_attribute(:started, true)

      expect do
        click_button "Bet on Gable Steveson"
      end.to change(WrestleBet::SpreadBet, :count).by (0)

      expect(page).to have_content("Match has already started")
    end

    it "lets you bet on the home wrestler" do
      sign_in(@user)
      visit @betslip_path
      expect(page).to have_content("hello Betslip")

      expect do
        click_button "Bet on Gable Steveson"
      end.to change(WrestleBet::SpreadBet, :count).by (1)

      bet = WrestleBet::SpreadBet.last!
      expect(bet.user_id).to eq(@user.id)
      expect(bet.match_id).to eq(@match.id)
      expect(bet.wager).to eq("home")

      expect(page).to have_content("Bet on Gable Steveson placed")
      expect(page).to have_content("hello Betslip")
    end

    it "lets you bet on the away wrestler" do
      sign_in(@user)
      visit @betslip_path
      expect(page).to have_content("hello Betslip")

      expect do
        click_button "Bet on Greg Kerkvliet"
      end.to change(WrestleBet::SpreadBet, :count).by (1)

      bet = WrestleBet::SpreadBet.last!
      expect(bet.user_id).to eq(@user.id)
      expect(bet.match_id).to eq(@match.id)
      expect(bet.wager).to eq("away")

      expect(page).to have_content("Bet on Greg Kerkvliet placed")
      expect(page).to have_content("hello Betslip")
    end
  end

  describe "results" do
    # gable gets -6.5
    [
      # bet underdog
      {
        desc: "shows 'win' if you chose the underdog, and they won the match",
        bet: "Greg Kerkvliet", home_score: 0, away_score: 1, outcome: "Bet Won"
      },
      {
        desc: "shows 'win' if you chose the underdog, and they lost but covered the spread",
        bet: "Greg Kerkvliet", home_score: 10, away_score: 4, outcome: "Bet Won"
      },
      {
        desc: "shows 'loss' if you chose the underdog, and they lost more than the spread",
        bet: "Greg Kerkvliet", home_score: 10, away_score: 3, outcome: "Bet Lost"
      },

      # bet favorite
      {
        desc: "shows 'win' if you chose the favorite, and they covered the spread",
        bet: "Gable Steveson", home_score: 10, away_score: 3, outcome: "Bet Won"
      },
      {
        desc: "shows 'loss' if you chose the favorite, and they win but did not cover the spread",
        bet: "Gable Steveson", home_score: 10, away_score: 4, outcome: "Bet Lost"
      },
      {
        desc: "shows 'loss' if you chose the favorite, and they lost the match",
        bet: "Gable Steveson", home_score: 0, away_score: 1, outcome: "Bet Lost"
      },
    ].each do |test_data|
      it test_data[:desc] do
        sign_in(@user)
        visit @betslip_path

        click_button "Bet on #{test_data[:bet]}"

        @match.update(test_data.slice(:home_score, :away_score))

        visit @betslip_path

        expect(page).to have_content(test_data[:outcome])
      end
    end
  end
end
