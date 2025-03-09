require 'rails_helper'

RSpec.describe "/wrestle_bet/matches", type: :request do
  
  before do
    sign_in FactoryBot.create(:user, :admin)
    @tournament = FactoryBot.create(:wrestle_bet_tournament)
    @home_wrestler = FactoryBot.create(:wrestle_bet_wrestler)
    @away_wrestler = FactoryBot.create(:wrestle_bet_wrestler)
    @valid_attributes = {
      home_wrestler_id: @home_wrestler.id,
      away_wrestler_id: @away_wrestler.id,
      tournament_id: @tournament.id,
      weight: 149,
      spread: 1.5,
    }

    @invalid_attributes = @valid_attributes.merge(weight: nil)
  end

  describe "GET /index" do
    it "renders a successful response" do
      WrestleBet::Match.create! @valid_attributes
      get wrestle_bet_matches_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      match = WrestleBet::Match.create! @valid_attributes
      get wrestle_bet_match_url(match)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_wrestle_bet_match_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      match = WrestleBet::Match.create! @valid_attributes
      get edit_wrestle_bet_match_url(match)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new WrestleBet::Match" do
        expect {
          post wrestle_bet_matches_url, params: { wrestle_bet_match: @valid_attributes }
        }.to change(WrestleBet::Match, :count).by(1)
      end

      it "redirects to the created wrestle_bet_match" do
        post wrestle_bet_matches_url, params: { wrestle_bet_match: @valid_attributes }
        match = WrestleBet::Match.last!
        expect(response).to redirect_to(wrestle_bet_match_url(match))
      end

      it "writes the expected parameters" do
        post wrestle_bet_matches_url, params: { wrestle_bet_match: @valid_attributes }
        match = WrestleBet::Match.last!

        expect(match.weight).to eq(149)
        expect(match.tournament_id).to eq(@tournament.id)
        expect(match.home_wrestler_id).to eq(@home_wrestler.id)
        expect(match.away_wrestler_id).to eq(@away_wrestler.id)
        expect(match.spread).to eq(1.5)
      end
    end

    context "with invalid parameters" do
      it "does not create a new WrestleBet::Match" do
        expect {
          post wrestle_bet_matches_url, params: { wrestle_bet_match: @invalid_attributes }
        }.to change(WrestleBet::Match, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post wrestle_bet_matches_url, params: { wrestle_bet_match: @invalid_attributes }
        expect(response.code).to eq("422")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      before do
        @new_attributes = @valid_attributes.merge(weight: 157)
      end

      it "updates the requested wrestle_bet_match" do
        match = WrestleBet::Match.create! @valid_attributes
        patch wrestle_bet_match_url(match), params: { wrestle_bet_match: @new_attributes }
        match.reload
        expect(match.weight).to eq(157)
      end

      it "redirects to the wrestle_bet_match" do
        match = WrestleBet::Match.create! @valid_attributes
        patch wrestle_bet_match_url(match), params: { wrestle_bet_match: @new_attributes }
        match.reload
        expect(response).to redirect_to(wrestle_bet_match_url(match))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        match = WrestleBet::Match.create! @valid_attributes
        patch wrestle_bet_match_url(match), params: { wrestle_bet_match: @invalid_attributes }
        expect(response.code).to eq("422")
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested wrestle_bet_match" do
      match = WrestleBet::Match.create! @valid_attributes
      expect {
        delete wrestle_bet_match_url(match)
      }.to change(WrestleBet::Match, :count).by(-1)
    end

    it "redirects to the wrestle_bet_matches list" do
      match = WrestleBet::Match.create! @valid_attributes
      delete wrestle_bet_match_url(match)
      expect(response).to redirect_to(wrestle_bet_matches_url)
    end
  end
end
