 require 'rails_helper'

RSpec.describe "/wrestle_bet/prop_bets", type: :request do
  
  before do
    @user = FactoryBot.create(:user, :admin)
    sign_in(@user)
    @tournament = FactoryBot.create(:wrestle_bet_tournament)
    @valid_attributes = {
      tournament_id: @tournament.id,
      jesus: 4,
      exposure: 4,
      challenges: 6,
      user_id: @user.id
    }

    @invalid_attributes = @valid_attributes.merge(challenges: "not-a-number")
  end


  describe "GET /index" do
    it "renders a successful response" do
      WrestleBet::PropBet.create! @valid_attributes
      get wrestle_bet_prop_bets_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      prop_bet = WrestleBet::PropBet.create! @valid_attributes
      get wrestle_bet_prop_bet_url(prop_bet)
      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    xit "ADD SPEC"
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new WrestleBet::PropBet" do
        expect {
          post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @valid_attributes }
        }.to change(WrestleBet::PropBet, :count).by(1)
      end

      it "removes prior Prop Bets for that match/user" do
        expect {
          post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @valid_attributes }
        }.to change(WrestleBet::PropBet, :count).by(1)
        first_bet = WrestleBet::PropBet.last!

        expect {
          post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @valid_attributes }
        }.to change(WrestleBet::PropBet, :count).by(0)
        second_bet = WrestleBet::PropBet.last!

        expect(second_bet.id).to_not eq(first_bet.id)
      end

      it "doesn't remove old bets for other users" do
        other_user_bet = FactoryBot.create(:wrestle_bet_prop_bet)
        post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @valid_attributes }

        expect(other_user_bet.reload.id).to_not be_nil
      end

      it "doesn't remove old bets for other tournaments" do
        other_bet = FactoryBot.create(:wrestle_bet_prop_bet, user: @user)
        post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @valid_attributes }

        expect(other_bet.reload.id).to_not be_nil
      end

      it "redirects to the created wrestle_bet_prop_bet" do
        post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @valid_attributes }
        bet = WrestleBet::PropBet.last!
        betslip_url = wrestle_bet_betslip_url(id: @tournament.id)
        expect(response).to redirect_to(betslip_url)
      end

      it "redirects to the betslip without placing a bet if the tournament has started" do
        FactoryBot.create(:wrestle_bet_match, tournament: @tournament, home_score: 3, away_score: 5)
        expect {
          post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @valid_attributes }
        }.to change(WrestleBet::PropBet, :count).by(0)
        expect(response.code).to eq("302")
      end
    end

    context "with invalid parameters" do
      it "does not create a new WrestleBet::PropBet" do
        expect {
          post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @invalid_attributes }
        }.to change(WrestleBet::PropBet, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post wrestle_bet_prop_bets_url, params: { wrestle_bet_prop_bet: @invalid_attributes }
        expect(response.code).to eq("302")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested wrestle_bet_prop_bet" do
      prop_bet = WrestleBet::PropBet.create! @valid_attributes
      expect {
        delete wrestle_bet_prop_bet_url(prop_bet)
      }.to change(WrestleBet::PropBet, :count).by(-1)
    end

    it "redirects to the wrestle_bet_prop_bets list" do
      prop_bet = WrestleBet::PropBet.create! @valid_attributes
      delete wrestle_bet_prop_bet_url(prop_bet)
      expect(response).to redirect_to(wrestle_bet_prop_bets_url)
    end
  end
end
