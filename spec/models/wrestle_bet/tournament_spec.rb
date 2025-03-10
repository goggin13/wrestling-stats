require 'rails_helper'

RSpec.describe WrestleBet::Tournament, type: :model do
  before do
    @tournament = FactoryBot.create(:wrestle_bet_tournament)
  end

  describe "current_match" do

    it "returns nil if there are no matches" do
      expect(@tournament.current_match).to eq(nil)
    end

    it "returns the first match that has started but has no score" do
      match = FactoryBot.create(:wrestle_bet_match,
        tournament: @tournament,
        started: true,
        home_score: nil,
        away_score: nil,
        spread: 4
     )

      expect(@tournament.current_match.id).to eq(match.id)
    end

    it "does not return a match that has not started" do
      match = FactoryBot.create(:wrestle_bet_match,
        tournament: @tournament,
        started: false,
        home_score: nil,
        away_score: nil
     )

      expect(@tournament.current_match).to be_nil
    end

    it "does not return a match that has started but has a home score" do
      match = FactoryBot.create(:wrestle_bet_match,
        tournament: @tournament,
        started: true,
        home_score: 10,
        away_score: nil
     )

      expect(@tournament.current_match).to be_nil
    end


    it "does not return a match that has started but has an away score" do
      match = FactoryBot.create(:wrestle_bet_match,
        tournament: @tournament,
        started: true,
        home_score: nil,
        away_score: 10
     )

      expect(@tournament.current_match).to be_nil
    end

  end
end
