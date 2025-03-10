require 'rails_helper'

RSpec.describe WrestleBet::Leaderboard, type: :model do
  describe "rankings" do
    before do
      @tournament = FactoryBot.create(:wrestle_bet_tournament)
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)

      # home covers
      @match = FactoryBot.create(:wrestle_bet_match,
                                 tournament: @tournament,
                                 spread: -1.5,
                                 home_score: 2,
                                 away_score: 0)
    end

    it "returns a hash of points to array of users" do
      winning_bet = FactoryBot.create(:wrestle_bet_spread_bet,
                                      match: @match,
                                      user: @user1,
                                      wager: "home")
      expect(winning_bet.won?).to eq(true)
      losing_bet = FactoryBot.create(:wrestle_bet_spread_bet,
                                      match: @match,
                                      user: @user2,
                                      wager: "away")
      expect(losing_bet.won?).to eq(false)

      leaderboard = WrestleBet::Leaderboard.new(@tournament)

      rankings = leaderboard.rankings
      expect(rankings[1][:points]).to eq(1)
      expect(rankings[1][:users]).to eq([@user1])
      expect(rankings[2][:points]).to eq(0)
      expect(rankings[2][:users]).to eq([@user2])
    end

    it "groups users with the same score" do
      winning_bet = FactoryBot.create(:wrestle_bet_spread_bet,
                                      match: @match,
                                      user: @user1,
                                      wager: "home")
      expect(winning_bet.won?).to eq(true)
      winning_bet_2 = FactoryBot.create(:wrestle_bet_spread_bet,
                                      match: @match,
                                      user: @user2,
                                      wager: "home")
      expect(winning_bet_2.won?).to eq(true)

      leaderboard = WrestleBet::Leaderboard.new(@tournament)

      rankings = leaderboard.rankings
      expect(rankings[1][:points]).to eq(1)
      expect(rankings[1][:users].sort).to eq([@user1, @user2].sort)
    end
  end
end

