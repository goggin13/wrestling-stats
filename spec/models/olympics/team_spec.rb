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

  describe "better_than?" do
    before do
      @team_A = FactoryBot.create(:olympics_team)
      @team_B = FactoryBot.create(:olympics_team)
    end

    it "returns true if the second team has fewer points" do
      FactoryBot.create(:olympics_match, team_1: @team_A, winning_team: @team_A)

      expect(@team_A.better_than?(@team_B)).to eq(true)
    end

    it "returns false if the second team has more points" do
      FactoryBot.create(:olympics_match, team_1: @team_B, winning_team: @team_B)

      expect(@team_A.better_than?(@team_B)).to eq(false)
    end

    it "returns false if the second team has the same points" do
      FactoryBot.create(:olympics_match, team_1: @team_A, winning_team: @team_A)
      FactoryBot.create(:olympics_match, team_1: @team_B, winning_team: @team_B)

      expect(@team_A.better_than?(@team_B)).to eq(false)
    end

    it "returns false if each team has no matches" do
      FactoryBot.create(:olympics_match, team_1: @team_A, winning_team: @team_A)
      FactoryBot.create(:olympics_match, team_1: @team_B, winning_team: @team_B)

      expect(@team_A.better_than?(@team_B)).to eq(false)
    end

    describe "tied on points" do
      before do
      end

      it "returns true if the first team has more head to head wins" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B, winning_team: @team_A)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, winning_team: @team_B)

        expect(@team_A.better_than?(@team_B)).to eq(true)
        expect(@team_B.better_than?(@team_A)).to eq(false)
      end

      it "returns false if the second team has more head to head wins" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_A, winning_team: @team_B)
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, winning_team: @team_A)

        expect(@team_A.better_than?(@team_B)).to eq(false)
        expect(@team_B.better_than?(@team_A)).to eq(true)
      end

      it "returns false if they have each won once head to head" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_A, winning_team: @team_B)
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B, winning_team: @team_A)

        expect(@team_A.better_than?(@team_B)).to eq(false)
      end
    end

    describe "tied on points and head to head" do
      it "returns if a team has fewer bp_cups" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B,
                          winning_team: @team_A, bp_cups_remaining: 5)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_A,
                          winning_team: @team_B, bp_cups_remaining: 2)

        expect(@team_A.better_than?(@team_B)).to eq(true)
        expect(@team_B.better_than?(@team_A)).to eq(false)
      end

      it "returns false if the teams have the same bp_cups" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B,
                          winning_team: @team_A, bp_cups_remaining: 5)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_A,
                          winning_team: @team_B, bp_cups_remaining: 5)

        expect(@team_A.better_than?(@team_B)).to eq(false)
        expect(@team_B.better_than?(@team_A)).to eq(false)
      end
    end
  end
end
