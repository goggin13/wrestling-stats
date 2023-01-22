require 'rails_helper'

module Olympics
  RSpec.describe ScoreboardPresenter, type: :model do
    describe "now_playing" do
      it "returns an array with two matches where now_playing is true" do
        match_1 = FactoryBot.create(:olympics_match, :now_playing)
        match_2 = FactoryBot.create(:olympics_match, :now_playing)
        presenter = ScoreboardPresenter.new

        now_playing = presenter.now_playing

        expect(now_playing.length).to eq(2)
        expect(now_playing[0]).to eq(match_1)
        expect(now_playing[1]).to eq(match_2)
      end

      it "returns two matches ordered by bout number" do
        match_2 = FactoryBot.create(:olympics_match, :now_playing, bout_number: 3)
        match_1 = FactoryBot.create(:olympics_match, :now_playing, bout_number: 2)
        presenter = ScoreboardPresenter.new

        now_playing = presenter.now_playing

        expect(now_playing.length).to eq(2)
        expect(now_playing[0]).to eq(match_1)
        expect(now_playing[1]).to eq(match_2)
      end

      it "doesn't return matches that have now_playing = false" do
        FactoryBot.create(:olympics_match, now_playing: false)
        presenter = ScoreboardPresenter.new

        now_playing = presenter.now_playing

        expect(now_playing.length).to eq(0)
      end
    end

    describe "on_deck" do
      it "doesn't include now_playing" do
        match_1 = FactoryBot.create(:olympics_match, :now_playing, bout_number: 1)
        presenter = ScoreboardPresenter.new

        on_deck = presenter.on_deck

        expect(on_deck.length).to eq(0)
      end

      it "returns an array with two matches" do
        match_1 = FactoryBot.create(:olympics_match, bout_number: 1)
        match_2 = FactoryBot.create(:olympics_match, bout_number: 2)
        presenter = ScoreboardPresenter.new

        on_deck = presenter.on_deck

        expect(on_deck.length).to eq(2)
        expect(on_deck[0]).to eq(match_1)
        expect(on_deck[1]).to eq(match_2)
      end

      it "doesn't return matches that have a winner" do
        FactoryBot.create(:olympics_match, :won)
        presenter = ScoreboardPresenter.new

        on_deck = presenter.on_deck

        expect(on_deck.length).to eq(0)
      end

      it "returns two matches ordered by bout number" do
        FactoryBot.create(:olympics_match, bout_number: 3)
        match_2 = FactoryBot.create(:olympics_match, bout_number: 2)
        match_1 = FactoryBot.create(:olympics_match, bout_number: 1)
        presenter = ScoreboardPresenter.new

        on_deck = presenter.on_deck

        expect(on_deck.length).to eq(2)
        expect(on_deck[0]).to eq(match_1)
        expect(on_deck[1]).to eq(match_2)
      end

      it "accepts an offset to show the next two on deck (aka 'in the hole')" do
        match_1 = FactoryBot.create(:olympics_match, :won, bout_number: 1)
        match_2 = FactoryBot.create(:olympics_match, bout_number: 2)
        match_3 = FactoryBot.create(:olympics_match, bout_number: 3)
        match_4 = FactoryBot.create(:olympics_match, bout_number: 4)
        match_5 = FactoryBot.create(:olympics_match, bout_number: 5)
        presenter = ScoreboardPresenter.new

        on_deck = presenter.on_deck(2)

        expect(on_deck.length).to eq(2)
        expect(on_deck[0]).to eq(match_4)
        expect(on_deck[1]).to eq(match_5)
      end
    end
  end

  # [
  #   {
  #     rank: 1,
  #     points: 5,
  #     teams: [],
  #   }
  # ]
  describe "rankings" do
    before do
      @team_A = FactoryBot.create(:olympics_team, name: "AAAA")
      @team_B = FactoryBot.create(:olympics_team, name: "BBBB")
      @team_C = FactoryBot.create(:olympics_team, name: "CCCC")
    end

    it "returns a hash of places to teams" do
      FactoryBot.create(:olympics_match,
                        team_1: @team_A, team_2: @team_B, winning_team: @team_A)
      FactoryBot.create(:olympics_match,
                        team_1: @team_A, team_2: @team_C, winning_team: @team_A)
      FactoryBot.create(:olympics_match,
                        team_1: @team_B, team_2: @team_C, winning_team: @team_B)

      rankings = ScoreboardPresenter.new.rankings

      expect(rankings.length).to eq(3)
      expect(rankings[0]).to eq({rank: 1, points: 2, teams: [@team_A]})
      expect(rankings[1]).to eq({rank: 2, points: 1, teams: [@team_B]})
      expect(rankings[2]).to eq({rank: 3, points: 0, teams: [@team_C]})
    end

    it "manages nil winning_ids" do
      FactoryBot.create(:olympics_match, team_1: @team_A, team_2: @team_B)

      rankings = ScoreboardPresenter.new.rankings

      expect(rankings.length).to eq(1)
    end

    describe "ties" do
      it "includes tied teams" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B, winning_team: @team_A)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_C, winning_team: @team_B)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(2)
        expect(rankings[0]).to eq({
          rank: 1,
          points: 1,
          teams: [@team_A, @team_B],
          tiebreaker_message: "AAAA owns tiebreaker on H2H"
        })
        expect(rankings[1]).to eq({rank: 3, points: 0, teams: [@team_C]})
      end

      it "sorts 2 tied teams by head to head" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_A, winning_team: @team_B)
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_C, winning_team: @team_A)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(2)
        expect(rankings[0]).to eq({
          rank: 1,
          points: 1,
          teams: [@team_B, @team_A],
          tiebreaker_message: "BBBB owns tiebreaker on H2H"
        })
      end

      it "sorts 2 tied teams by head to head" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_A, winning_team: @team_A)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_C, winning_team: @team_B)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(2)
        expect(rankings[0]).to eq({
          rank: 1,
          points: 1,
          teams: [@team_A, @team_B],
          tiebreaker_message: "AAAA owns tiebreaker on H2H"
        })
      end

      it "returns a tie breaker message for two teams with the same BP cups" do
        FactoryBot.create(:olympics_match, :beer_pong,
                          team_1: @team_B,
                          winning_team: @team_B,
                          bp_cups_remaining: 3)
        FactoryBot.create(:olympics_match,
                          team_1: @team_A,
                          winning_team: @team_A)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(2)
        expect(rankings[0]).to eq({
          rank: 1,
          points: 1,
          teams: [@team_B, @team_A],
          tiebreaker_message: "BBBB owns tiebreaker on BP cups"
        })
      end

      it "sorts 2 tied teams by BP cups" do
        FactoryBot.create(:olympics_match, :beer_pong,
                          team_1: @team_A,
                          winning_team: @team_A,
                          bp_cups_remaining: 3)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B,
                          winning_team: @team_B)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(2)
        expect(rankings[0]).to eq({
          rank: 1,
          points: 1,
          teams: [@team_A, @team_B],
          tiebreaker_message: "AAAA owns tiebreaker on BP cups"
        })
      end
    end
  end
end
