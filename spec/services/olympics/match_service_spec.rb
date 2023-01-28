require "rails_helper.rb"
require "csv"

describe Olympics::MatchService do
  describe "import_from_file" do
    it "creates a new match" do
      team_A = FactoryBot.create(:olympics_team, number: 3)
      team_B = FactoryBot.create(:olympics_team, number: 5)

      temp_file = Tempfile.new(["test_matchups", ".csv"])
      CSV.open(temp_file.path, "w") do |csv|
        csv << [17, 3, 5, "beer_pong"]
      end

      expect do
        Olympics::MatchService.import_from_file(temp_file.path)
      end.to change(Olympics::Match, :count).by(1)

      match = Olympics::Match.last!
      expect(match.bout_number).to eq(17)
      expect(match.team_1.id).to eq(team_A.id)
      expect(match.team_2.id).to eq(team_B.id)
      expect(match.event).to eq(Olympics::Match::Events::BEER_PONG)
    end
  end

  describe "update" do
    describe "updating winner_id and advancing now_playing" do
      it "sets the matches now_playing to false on success" do
        match_1 = FactoryBot.create(:olympics_match, :now_playing)
        Olympics::MatchService.update(match_1, winning_team_id: match_1.team_1.id)

        match_1.reload

        expect(match_1.now_playing).to be false
        expect(match_1.winning_team_id).to eq(match_1.team_1.id)
      end

      it "doesn't set the matches now_playing to false if update fails" do
        match_1 = FactoryBot.create(:olympics_match, :now_playing)
        Olympics::MatchService.update(match_1,
          winning_team_id: match_1.team_1.id,
          bout_number: nil
        )

        match_1.reload

        expect(match_1.now_playing).to be true
      end

      it "doesn't set the matches now_playing to false if winning_team_id is not being updated" do
        match_1 = FactoryBot.create(:olympics_match, :now_playing)
        Olympics::MatchService.update(match_1,
          bout_number: 77
        )

        match_1.reload

        expect(match_1.bout_number).to eq(77)
        expect(match_1.now_playing).to eq(true)
      end

      it "sets the next match now_playing to true" do
        match_1 = FactoryBot.create(:olympics_match, :now_playing)
        match_2 = FactoryBot.create(:olympics_match, :now_playing)
        match_3 = FactoryBot.create(:olympics_match, now_playing: false)
        result = Olympics::MatchService.update(
          match_1,
          winning_team_id: match_1.team_1.id
        )

        expect(result).to eq(true)

        match_1.reload
        match_2.reload
        match_3.reload

        expect(match_1.now_playing).to be false
        expect(match_2.now_playing).to be true
        expect(match_3.now_playing).to be true
      end

      it "chooses the next match to play that doesn't have currently playing teams" do
        team_A = FactoryBot.create(:olympics_team)
        team_B = FactoryBot.create(:olympics_team)
        team_C = FactoryBot.create(:olympics_team)
        team_D = FactoryBot.create(:olympics_team)
        team_E = FactoryBot.create(:olympics_team)
        match_1 = FactoryBot.create(:olympics_match, :now_playing, team_1: team_A, team_2: team_B)
        match_2 = FactoryBot.create(:olympics_match, :now_playing, team_1: team_C, team_2: team_D)
        match_3 = FactoryBot.create(:olympics_match, now_playing: false, team_1: team_A, team_2: team_D)
        match_4 = FactoryBot.create(:olympics_match, now_playing: false, team_1: team_B, team_2: team_C)
        match_5 = FactoryBot.create(:olympics_match, now_playing: false, team_1: team_A, team_2: team_E)

        result = Olympics::MatchService.update(match_1, winning_team_id: team_A.id)
        expect(result).to eq(true)

        match_1.reload
        match_2.reload
        match_3.reload
        match_4.reload
        match_5.reload

        expect(match_1.now_playing).to be false
        expect(match_2.now_playing).to be true
        expect(match_3.now_playing).to be false
        expect(match_4.now_playing).to be false
        expect(match_5.now_playing).to be true
      end

      it "doesn't use matches that have been won" do
        match_1 = FactoryBot.create(:olympics_match, :now_playing)
        match_2 = FactoryBot.create(:olympics_match, :won, now_playing: false)
        match_3 = FactoryBot.create(:olympics_match, now_playing: false)
        Olympics::MatchService.update(match_1, winning_team_id: match_1.team_1.id)

        match_1.reload
        match_2.reload
        match_3.reload

        expect(match_1.now_playing).to be false
        expect(match_2.now_playing).to be false
        expect(match_3.now_playing).to be true
      end

      it "doesn't set an earlier matches now_playing when resetting an old match" do
        match_1 = FactoryBot.create(:olympics_match, :won, now_playing: false)
        Olympics::MatchService.update(match_1, winning_team_id: nil)

        match_1.reload

        expect(match_1.now_playing).to be false
      end

      it "doesn't set an earlier matches now_playing when resetting an old match with ''" do
        match_1 = FactoryBot.create(:olympics_match, :won, now_playing: false)
        Olympics::MatchService.update(match_1, winning_team_id: "")

        match_1.reload

        expect(match_1.now_playing).to be false
      end

      it "sets bp_cups_remaining=0 if setting winner_id to ''" do
        match_1 = FactoryBot.create(:olympics_match, :won, now_playing: false, bp_cups_remaining: 2)
        Olympics::MatchService.update(match_1, winning_team_id: "")

        match_1.reload

        expect(match_1.bp_cups_remaining).to eq(0)
      end

      it "doesn't advance a match from a new event" do
        match_1 = FactoryBot.create(:olympics_match, :beer_pong, :now_playing)
        match_2 = FactoryBot.create(:olympics_match, :beer_pong, :now_playing)
        match_3 = FactoryBot.create(:olympics_match, :flip_cup, now_playing: false)
        Olympics::MatchService.update(match_1, winning_team_id: match_1.team_1.id)

        match_1.reload
        match_2.reload
        match_3.reload

        expect(match_1.now_playing).to be false
        expect(match_2.now_playing).to be true
        expect(match_3.now_playing).to be false
      end

      it "advances two matches from the next event when an event finishes" do
        match_1 = FactoryBot.create(:olympics_match, :beer_pong, :now_playing)
        match_2 = FactoryBot.create(:olympics_match, :flip_cup, now_playing: false)
        match_3 = FactoryBot.create(:olympics_match, :flip_cup, now_playing: false)
        Olympics::MatchService.update(match_1, winning_team_id: match_1.team_1.id)

        match_1.reload
        match_2.reload
        match_3.reload

        expect(match_1.now_playing).to be false
        expect(match_2.now_playing).to be true
        expect(match_3.now_playing).to be true
      end
    end
  end
end
