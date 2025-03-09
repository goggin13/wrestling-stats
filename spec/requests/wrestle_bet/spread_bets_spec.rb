 require 'rails_helper'

RSpec.describe "/wrestle_bet/spread_bets", type: :request do
  
  before do
    @user = FactoryBot.create(:user, :admin)
    sign_in(@user)
    @match = FactoryBot.create(:wrestle_bet_match)
    @valid_attributes = {
      user_id: @user.id,
      match_id: @match.id,
      wager: "home",
    }

    @invalid_attributes = @valid_attributes.merge(wager: "not-a-wager")
  end

  describe "GET /index" do
    it "renders a successful response" do
      WrestleBet::SpreadBet.create! @valid_attributes
      get wrestle_bet_spread_bets_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      spread_bet = WrestleBet::SpreadBet.create! @valid_attributes
      get wrestle_bet_spread_bet_url(spread_bet)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_wrestle_bet_spread_bet_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      spread_bet = WrestleBet::SpreadBet.create! @valid_attributes
      get edit_wrestle_bet_spread_bet_url(spread_bet)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new WrestleBet::SpreadBet" do
        expect {
          post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        }.to change(WrestleBet::SpreadBet, :count).by(1)
      end

      it "redirects to the created wrestle_bet_spread_bet" do
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        bet = WrestleBet::SpreadBet.last!
        expect(response).to redirect_to(wrestle_bet_spread_bet_url(bet))
      end

      it "creates assigned to the authenticated user" do
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        bet = WrestleBet::SpreadBet.last!
        expect(bet.user_id).to eq(@user.id)
      end
    end

    context "with invalid parameters" do
      it "does not create a new WrestleBet::SpreadBet" do
        expect {
          post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @invalid_attributes }
        }.to change(WrestleBet::SpreadBet, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @invalid_attributes }
        expect(response.code).to eq("422")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        @new_attributes = @valid_attributes.merge(wager: "away")
      end

      it "updates the requested wrestle_bet_spread_bet" do
        spread_bet = WrestleBet::SpreadBet.create! @valid_attributes
        patch wrestle_bet_spread_bet_url(spread_bet), params: { wrestle_bet_spread_bet: @new_attributes }
        spread_bet.reload
        expect(spread_bet.wager).to eq("away")
      end

      it "redirects to the wrestle_bet_spread_bet" do
        spread_bet = WrestleBet::SpreadBet.create! @valid_attributes
        patch wrestle_bet_spread_bet_url(spread_bet), params: { wrestle_bet_spread_bet: @new_attributes }
        spread_bet.reload
        expect(response).to redirect_to(wrestle_bet_spread_bet_url(spread_bet))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        spread_bet = WrestleBet::SpreadBet.create! @valid_attributes
        patch wrestle_bet_spread_bet_url(spread_bet), params: { wrestle_bet_spread_bet: @invalid_attributes }
        expect(response.code).to eq("422")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested wrestle_bet_spread_bet" do
      spread_bet = WrestleBet::SpreadBet.create! @valid_attributes
      expect {
        delete wrestle_bet_spread_bet_url(spread_bet)
      }.to change(WrestleBet::SpreadBet, :count).by(-1)
    end

    it "redirects to the wrestle_bet_spread_bets list" do
      spread_bet = WrestleBet::SpreadBet.create! @valid_attributes
      delete wrestle_bet_spread_bet_url(spread_bet)
      expect(response).to redirect_to(wrestle_bet_spread_bets_url)
    end
  end
end
