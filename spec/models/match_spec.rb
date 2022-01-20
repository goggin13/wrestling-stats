require 'rails_helper'

RSpec.describe Match do
  before do
    @away = FactoryBot.create(:college, name: "Lehigh")
    @home = FactoryBot.create(:college, name: "Cornell")
  end

  describe "top_matchups" do
    it "returns matchups with top 15 wrestlers" do
      home_wrestler = FactoryBot.create(:wrestler, rank: 1, weight: 149, college: @home)
      away_wrestler = FactoryBot.create(:wrestler, rank: 7, weight: 149, college: @away)
      match = FactoryBot.create(:match, home_team: @home, away_team: @away)

      results = match.top_matchups

      expect(results.first).to eq([away_wrestler, home_wrestler])
    end

    it "doesn't returns matchups with top 16 wrestlers" do
      home_wrestler = FactoryBot.create(:wrestler, rank: 16, weight: 149, college: @home)
      away_wrestler = FactoryBot.create(:wrestler, rank: 16, weight: 149, college: @away)
      match = FactoryBot.create(:match, home_team: @home, away_team: @away)

      expect(match.top_matchups).to eq([])
    end
  end
end
