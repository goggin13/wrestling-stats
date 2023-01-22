require 'rails_helper'

RSpec.describe Olympics::Team, type: :model do
  describe "wins_over" do
    it "returns the number of wins against another team" do
      team_A = FactoryBot.create(:olympics_team)
      team_B = FactoryBot.create(:olympics_team)
      FactoryBot.create(:olympics_match,
                        team_1: team_B, team_2: team_A, winning_team: team_A)

      expect(team_A.wins_over(team_B)).to eq(1)
      expect(team_B.wins_over(team_A)).to eq(0)
    end
  end

  describe "bp_cups" do
    it "returns the number of bp_cups from wins" do
      team_A = FactoryBot.create(:olympics_team)
      FactoryBot.create(:olympics_match, :beer_pong, team_1: team_A,
                        bp_cups_remaining: 4, winning_team: team_A)
      FactoryBot.create(:olympics_match, :beer_pong, team_1: team_A,
                        bp_cups_remaining: 3, winning_team: team_A)

      expect(team_A.bp_cups).to eq(7)
    end

    it "subtracts the number of bp_cups from losses" do
      team_A = FactoryBot.create(:olympics_team)
      team_B = FactoryBot.create(:olympics_team)
      FactoryBot.create(:olympics_match, :beer_pong, team_1: team_A,
                        bp_cups_remaining: 4, winning_team: team_A)
      FactoryBot.create(:olympics_match, :beer_pong, team_1: team_A,
                        bp_cups_remaining: 3, winning_team: team_B)

      expect(team_A.bp_cups).to eq(1)
    end
  end
end
