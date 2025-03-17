require 'rails_helper'

RSpec.describe WrestleBet::PropBet, type: :model do
  describe "won_jesus?" do
    it "is true if you are the closest guess" do
      tournament = FactoryBot.create(:wrestle_bet_tournament, jesus: 3)
      winning_bet = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, jesus: 4)
      winning_bet_2 = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, jesus: 2)
      losing_bet = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, jesus: 1)

      expect(winning_bet_2.won_jesus?).to eq(true)
      expect(winning_bet.won_jesus?).to eq(true)
      expect(losing_bet.won_jesus?).to eq(false)
    end
  end

  describe "won_exposure?" do
    it "is true if you are the closest guess" do
      tournament = FactoryBot.create(:wrestle_bet_tournament, exposure: 3)
      winning_bet = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, exposure: 4)
      winning_bet_2 = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, exposure: 2)
      losing_bet = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, exposure: 1)

      expect(winning_bet_2.won_exposure?).to eq(true)
      expect(winning_bet.won_exposure?).to eq(true)
      expect(losing_bet.won_exposure?).to eq(false)
    end
  end

  describe "won_challenges?" do
    it "is true if you are the closest guess" do
      tournament = FactoryBot.create(:wrestle_bet_tournament, challenges: 3)
      winning_bet = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, challenges: 4)
      winning_bet_2 = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, challenges: 2)
      losing_bet = FactoryBot.create(:wrestle_bet_prop_bet,
        tournament: tournament, challenges: 1)

      expect(winning_bet_2.won_challenges?).to eq(true)
      expect(winning_bet.won_challenges?).to eq(true)
      expect(losing_bet.won_challenges?).to eq(false)
    end
  end
end
