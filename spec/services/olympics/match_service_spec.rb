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
end
