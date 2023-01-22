require "rails_helper.rb"
require "csv"

describe Olympics::MatchService do
  before do
    @team_1 = FactoryBot.create(:olympics_team, number: 3)
    @team_2 = FactoryBot.create(:olympics_team, number: 5)
  end

  describe "import_from_file" do
    it "creates a new match" do
      temp_file = Tempfile.new(["test_matchups", ".csv"])
      CSV.open(temp_file.path, "w") do |csv|
        csv << [17, 3, 5, "beer_pong"]
      end

      expect do
        Olympics::MatchService.import_from_file(temp_file.path)
      end.to change(Olympics::Match, :count).by(1)

      match = Olympics::Match.last!
      expect(match.bout_number).to eq(17)
      expect(match.team_1.id).to eq(@team_1.id)
      expect(match.team_2.id).to eq(@team_2.id)
      expect(match.event).to eq(Olympics::Match::Events::BEER_PONG)
    end
  end

  describe "update" do
    describe "updating winner_id" do
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
    end
  end
end
