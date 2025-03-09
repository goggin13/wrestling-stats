 require 'rails_helper'

RSpec.describe "/wrestle_bet/spread_bets", type: :request do
  
  before do
    @user = FactoryBot.create(:user, :admin)
    sign_in(@user)
    @match = FactoryBot.create(:wrestle_bet_match)
    @tournament = @match.tournament
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

      it "removes prior wrestlebets for that match/user" do
        expect {
          post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        }.to change(WrestleBet::SpreadBet, :count).by(1)
        first_bet = WrestleBet::SpreadBet.last!

        expect {
          post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        }.to change(WrestleBet::SpreadBet, :count).by(0)
        second_bet = WrestleBet::SpreadBet.last!

        expect(second_bet.id).to_not eq(first_bet.id)
      end

      it "doesn't remove old bets for other users" do
        other_user_bet = FactoryBot.create(:wrestle_bet_spread_bet)
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }

        expect(other_user_bet.reload.id).to_not be_nil
      end

      it "doesn't remove old bets for other matches" do
        other_bet = FactoryBot.create(:wrestle_bet_spread_bet, user: @user)
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }

        expect(other_bet.reload.id).to_not be_nil
      end

      it "replaces an existing bet on the same match" do
        other_bet = FactoryBot.create(
          :wrestle_bet_spread_bet,
          match: @match,
          user: @user,
          wager: "home",
        )

        post wrestle_bet_spread_bets_url, params: {
          wrestle_bet_spread_bet: @valid_attributes.merge(wager: "away")
        }

        new_bet = WrestleBet::SpreadBet.last!
        old_bet = WrestleBet::SpreadBet.where(id: other_bet.id).first

        expect(old_bet).to be_nil
        expect(new_bet.wager).to eq("away")
      end

      it "redirects to the betslip" do
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        bet = WrestleBet::SpreadBet.last!
        betslip_url = wrestle_bet_betslip_url(id: @tournament.id)
        expect(response).to redirect_to(betslip_url)
      end

      it "creates assigned to the authenticated user" do
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        bet = WrestleBet::SpreadBet.last!
        expect(bet.user_id).to eq(@user.id)
      end

      it "redirects to the betslip without placing a bet if the match has started" do
        @match.update_attribute(:started, true)
        expect {
          post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @valid_attributes }
        }.to change(WrestleBet::SpreadBet, :count).by(0)
        expect(response.code).to eq("302")
      end
    end

    context "with invalid parameters" do
      it "does not create a new WrestleBet::SpreadBet" do
        expect {
          post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @invalid_attributes }
        }.to change(WrestleBet::SpreadBet, :count).by(0)
      end

      it "redirects to the betslip" do
        post wrestle_bet_spread_bets_url, params: { wrestle_bet_spread_bet: @invalid_attributes }
        expect(response.code).to eq("302")
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
