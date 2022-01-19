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
  end
end
