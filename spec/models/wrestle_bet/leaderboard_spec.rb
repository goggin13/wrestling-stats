require 'rails_helper'

RSpec.describe WrestleBet::Leaderboard, type: :model do
  describe "rankings" do
    before do
      @tournament = FactoryBot.create(:wrestle_bet_tournament,
        jesus: 3, exposure: 4, challenges: 5)
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

    describe "prop bets" do
      it "includes points from prop bets" do
        winning_bet = FactoryBot.create(:wrestle_bet_spread_bet,
                                        match: @match,
                                        user: @user1,
                                        wager: "home")
        prop_bet_win_x_3 = FactoryBot.create(:wrestle_bet_prop_bet,
          user: @user1,
          tournament: @tournament, jesus: 3, exposure: 4, challenges: 5)

        leaderboard = WrestleBet::Leaderboard.new(@tournament)

        rankings = leaderboard.rankings
        expect(rankings[1][:points]).to eq(4)
      end

      it "does not include prop bets if tournament is not completed" do
        winning_bet = FactoryBot.create(:wrestle_bet_spread_bet,
                                      match: @match,
                                      user: @user1,
                                      wager: "home")
        prop_bet_win_x_3 = FactoryBot.create(:wrestle_bet_prop_bet,
          user: @user1,
          tournament: @tournament, jesus: 3, exposure: 4, challenges: 5)
        unfinished_match = FactoryBot.create(:wrestle_bet_match,
                                 tournament: @tournament,
                                 spread: -1.5,
                                 home_score: nil,
                                 away_score: nil)

        leaderboard = WrestleBet::Leaderboard.new(@tournament)

        rankings = leaderboard.rankings
        expect(rankings[1][:points]).to eq(1)
      end


      it "awards 1 point per prop bet" do
        prop_bet_win_x_1 = FactoryBot.create(:wrestle_bet_prop_bet,
          user: @user1,
          tournament: @tournament, jesus: 4, exposure: 3, challenges: 2)
        prop_bet_win_x_1 = FactoryBot.create(:wrestle_bet_prop_bet,
          user: @user2,
          tournament: @tournament, jesus: 1, exposure: 8, challenges: 5)

        leaderboard = WrestleBet::Leaderboard.new(@tournament)

        rankings = leaderboard.rankings
        expect(rankings[1][:points]).to eq(2)
        expect(rankings[1][:users]).to eq([@user1])
        expect(rankings[2][:points]).to eq(1)
        expect(rankings[2][:users]).to eq([@user2])
      end

      it "yields a 3 way prop bet tie" do
        user3 = FactoryBot.create(:user)
        prop_bet_win_x_1 = FactoryBot.create(:wrestle_bet_prop_bet,
          user: @user1,
          tournament: @tournament, jesus: 2, exposure: 2, challenges: 6)
        prop_bet_win_x_1 = FactoryBot.create(:wrestle_bet_prop_bet,
          user: @user2,
          tournament: @tournament, jesus: 5, exposure: 5, challenges: 4)
        prop_bet_win_x_1 = FactoryBot.create(:wrestle_bet_prop_bet,
          user: user3,
          tournament: @tournament, jesus: 1, exposure: 7, challenges: 5)

        leaderboard = WrestleBet::Leaderboard.new(@tournament)

        rankings = leaderboard.rankings
        expect(rankings[1][:points]).to eq(1)
        expect(rankings[1][:users].sort).to eq([@user1, @user2, user3].sort)
      end
    end
  end
end

