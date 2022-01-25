require 'rails_helper'

RSpec.describe RawSchedule do
  before do
    @maryland = FactoryBot.create(:college, name: "Maryland")
    @indiana = FactoryBot.create(:college, name: "Indiana")
  end

  describe "ingest" do
    it "creates matches from the MATCHES array" do
      expect(RawSchedule).to receive(:matches).and_return(
        [['01/21/22', 'Maryland', 'Indiana']],
      )

      expect do
        RawSchedule.ingest
      end.to change(Match, :count).by(1)

      match = Match.first!
      expect(match.date).to eq(Date.strptime("01/21/22", "%m/%d/%y"))
      expect(match.away_team.id).to eq(@maryland.id)
      expect(match.home_team.id).to eq(@indiana.id)
    end

    it "sets a time if its provided" do
      expect(RawSchedule).to receive(:matches).and_return(
        [['01/21/22', 'Maryland', 'Indiana', '18:00']],
      )

      RawSchedule.ingest

      match = Match.first!
      expect(match.time).to eq("18:00")
    end

    it "accepts an empty time" do
      expect(RawSchedule).to receive(:matches).and_return(
        [['01/21/22', 'Maryland', 'Indiana', '']],
      )

      RawSchedule.ingest

      match = Match.first!
      expect(match.time).to eq(nil)
    end

    it "sets a time and a watch_on if its provided" do
      expect(RawSchedule).to receive(:matches).and_return(
        [['01/21/22', 'Maryland', 'Indiana', '18:00', 'ESPN']],
      )

      RawSchedule.ingest

      match = Match.first!
      expect(match.time).to eq("18:00")
      expect(match.watch_on).to eq("ESPN")
    end

    it "updates the date for an existing match" do
      expect(RawSchedule).to receive(:matches).and_return(
        [['01/21/22', 'Maryland', 'Indiana']],
      )
      RawSchedule.ingest

      first_match = Match.first!
      expect(RawSchedule).to receive(:matches).and_return(
        [['02/21/22', 'Maryland', 'Indiana', '19:00']],
      )
      RawSchedule.ingest

      second_match = Match.first!
      expect(second_match.date).to eq(Date.strptime("02/21/22", "%m/%d/%y"))
      expect(first_match.id).to eq(second_match.id)

      expect(Match.count).to eq(1)
    end
  end
end
