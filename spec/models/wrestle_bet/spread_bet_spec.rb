require 'rails_helper'

RSpec.describe WrestleBet::SpreadBet, type: :model do
  describe "won?" do
    it "is false if the match is not completed" do
      match = FactoryBot.create(:wrestle_bet_match, spread: -5.0, home_score: nil, away_score: nil)
      bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "home")
      expect(bet.won?).to eq(false)
    end

    context "home favored [spread is (-)]" do
			context "wager is home" do
				it "is true if home wrestler covers" do
          match = FactoryBot.create(:wrestle_bet_match, spread: -5.0, home_score: 16, away_score: 10)
					bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "home")
					expect(bet.won?).to eq(true)
				end

				it "is false if the home wrestler loses" do
					match = FactoryBot.create(:wrestle_bet_match, spread: -5, home_score: 6, away_score: 10)
					bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "home")
					expect(bet.won?).to eq(false)
				end

				it "is false if the home wrestler wins but does not cover" do
					match = FactoryBot.create(:wrestle_bet_match, spread: -5, home_score: 15, away_score: 10)
					bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "home")
					expect(bet.won?).to eq(false)
				end
			end

      context "wager is away" do
        it "is true if the wager is away and the away wrestler wins" do
          match = FactoryBot.create(:wrestle_bet_match, spread: -5, home_score: 4, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "away")
          expect(bet.won?).to eq(true)
        end

        it "is true if the wager is away and the away wrestler loses but covers" do
          match = FactoryBot.create(:wrestle_bet_match, spread: -5, home_score: 12, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "away")
          expect(bet.won?).to eq(true)
        end

        it "is false if the wager is away and the away wrestler loses by more than the spread" do
          match = FactoryBot.create(:wrestle_bet_match, spread: -5, home_score: 16, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "away")
          expect(bet.won?).to eq(false)
        end
      end
    end

    context "away favored [spread is (+)]" do
      context "wager is home" do
        it "is true if the wager is home and the home wrestler wins" do
          match = FactoryBot.create(:wrestle_bet_match, spread: 5, home_score: 15, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "home")
          expect(bet.won?).to eq(true)
        end

        it "is true if the wager is home and the home wrestler loses but covers" do
          match = FactoryBot.create(:wrestle_bet_match, spread: 5, home_score: 8, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "home")
          expect(bet.won?).to eq(true)
        end

        it "is false if the wager is home and the home wrestler loses by more than the spread" do
          match = FactoryBot.create(:wrestle_bet_match, spread: 5, home_score: 4, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "home")
          expect(bet.won?).to eq(false)
        end
      end

      context "wager is away" do
        it "is true if the wager is away and the away wrestler wins by more than the spread" do
          match = FactoryBot.create(:wrestle_bet_match, spread: 5, home_score: 4, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "away")
          expect(bet.won?).to eq(true)
        end

        it "is false if the wager is away and the away wrestler wins but does not cover" do
          match = FactoryBot.create(:wrestle_bet_match, spread: 5, home_score: 8, away_score: 10)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "away")
          expect(bet.won?).to eq(false)
        end

        it "is false if the wager is away and the away wrestler loses" do
          match = FactoryBot.create(:wrestle_bet_match, spread: 5, home_score: 16, away_score: 15)
          bet = FactoryBot.build(:wrestle_bet_spread_bet, match: match, wager: "away")
          expect(bet.won?).to eq(false)
        end
      end
    end
  end
end
