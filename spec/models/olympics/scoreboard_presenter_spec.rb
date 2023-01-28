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

  describe "rankings-new" do
    before do
      @team_A = FactoryBot.create(:olympics_team, name: "AAAA")
      @team_B = FactoryBot.create(:olympics_team, name: "BBBB")
      @team_C = FactoryBot.create(:olympics_team, name: "CCCC")
    end

    it "returns 3 teams sorted by points" do
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

    it "returns a 2 way tie for first" do
      FactoryBot.create(:olympics_match,
                        team_1: @team_A, team_2: @team_B,
                        winning_team: @team_A)
      FactoryBot.create(:olympics_match,
                        team_1: @team_A, team_2: @team_B,
                        winning_team: @team_B)

      rankings = ScoreboardPresenter.new.rankings

      expect(rankings.length).to eq(2)
      expect(rankings[0][:teams]).to eq([@team_A, @team_B])
      expect(rankings[1][:teams]).to eq([@team_C])

      expect(rankings[0]).to eq({rank: 1, points: 1, teams: [@team_A, @team_B]})
      expect(rankings[1]).to eq({rank: 3, points: 0, teams: [@team_C]})
    end

    it "returns a 3 way tie" do
      rankings = ScoreboardPresenter.new.rankings

      expect(rankings[0]).to eq({rank: 1, points: 0, teams: [@team_A, @team_B, @team_C]})
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

    it "returns 3 teams sorted by points" do
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

    it "returns a 2 way tie for first" do
      FactoryBot.create(:olympics_match,
                        team_1: @team_A, team_2: @team_B,
                        winning_team: @team_A)
      FactoryBot.create(:olympics_match,
                        team_1: @team_A, team_2: @team_B,
                        winning_team: @team_B)

      rankings = ScoreboardPresenter.new.rankings

      expect(rankings.length).to eq(2)
      expect(rankings[0][:teams]).to eq([@team_A, @team_B])
      expect(rankings[1][:teams]).to eq([@team_C])

      expect(rankings[0]).to eq({rank: 1, points: 1, teams: [@team_A, @team_B]})
      expect(rankings[1]).to eq({rank: 3, points: 0, teams: [@team_C]})
    end

    it "returns a 3 way tie" do
      rankings = ScoreboardPresenter.new.rankings

      expect(rankings[0]).to eq({rank: 1, points: 0, teams: [@team_A, @team_B, @team_C]})
    end

    it "manages nil winning_ids" do
      FactoryBot.create(:olympics_match, team_1: @team_A, team_2: @team_B)

      rankings = ScoreboardPresenter.new.rankings

      expect(rankings.length).to eq(1)
    end

    describe "ties" do
      it "sorts two teams tied on points" do
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B, winning_team: @team_A)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_C, winning_team: @team_B)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(3)
        expect(rankings[0]).to eq({ rank: 1, points: 1, teams: [@team_A]})
        expect(rankings[1]).to eq({rank: 2, points: 1, teams: [@team_B]})
        expect(rankings[2]).to eq({ rank: 3, points: 0, teams: [@team_C]})
      end

      it "handles a cyclic better_than relationship" do
        # A beats B, B beats C, C beats A
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B,
                          winning_team: @team_A)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_C,
                          winning_team: @team_B)
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_C,
                          winning_team: @team_C)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(1)
        expect(rankings[0]).to eq({
          rank: 1,
          points: 1,
          teams: [@team_A, @team_B, @team_C]
        })
      end

      it "handles a cyclic better_than relationship in the middle of a winning and losing team" do
        # A beats B, B beats C, C beats A
        # D beats E
        team_D = FactoryBot.create(:olympics_team, name: "DDDD")
        team_E = FactoryBot.create(:olympics_team, name: "EEEE")

        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_B,
                          winning_team: @team_A)
        FactoryBot.create(:olympics_match,
                          team_1: @team_B, team_2: @team_C,
                          winning_team: @team_B)
        FactoryBot.create(:olympics_match,
                          team_1: @team_A, team_2: @team_C,
                          winning_team: @team_C)
        FactoryBot.create(:olympics_match,
                          team_1: team_D, team_2: team_E,
                          winning_team: team_D,
                          bp_cups_remaining: 2)

        rankings = ScoreboardPresenter.new.rankings

        expect(rankings.length).to eq(3)
        expect(rankings[0]).to eq({rank: 1, points: 1, teams: [team_D]})
        expect(rankings[1]).to eq({
          rank: 2,
          points: 1,
          teams: [@team_A, @team_B, @team_C]
        })
        expect(rankings[2]).to eq({rank: 5, points: 0, teams: [team_E]})
      end
    end
  end
end
