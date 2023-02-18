require "rails_helper.rb"

describe WrestlerService do
  before do
    @away = FactoryBot.create(:college, name: "Lehigh")
    @home = FactoryBot.create(:college, name: "Cornell")
  end

  describe "preview" do
    it "returns a hash with the home and away teams" do
      result = MatchService.preview(@away, @home)
      expect(result[:home][:college].id).to eq(@home.id)
      expect(result[:away][:college].id).to eq(@away.id)
    end

    it "returns the ranked wrestlers for the home team" do
      @vito = FactoryBot.create(:wrestler,
        name: "Vito Arujao",
        weight: 125,
        rank: 2,
        college: @home
      )
      @yianni = FactoryBot.create(:wrestler,
        name: "Yianni Diakomihalis",
        weight: 149,
        rank: 1,
        college: @home
      )
      result = MatchService.preview(@away, @home)

      result[:home][125].id = @vito.id
      result[:home][149].id = @yianni.id
    end

    it "returns the ranked wrestlers for the away team" do
      @vito = FactoryBot.create(:wrestler,
        name: "Vito Arujao",
        weight: 125,
        rank: 2,
        college: @away
      )
      @yianni = FactoryBot.create(:wrestler,
        name: "Yianni Diakomihalis",
        weight: 149,
        rank: 1,
        college: @away
      )
      result = MatchService.preview(@away, @home)

      result[:away][125].id = @vito.id
      result[:away][149].id = @yianni.id
    end

    it "returns the predicted number of wins for each team" do
      FactoryBot.create(:wrestler, weight: 125, rank: 2, college: @away)
      FactoryBot.create(:wrestler, weight: 149, rank: 1, college: @home)
      result = MatchService.preview(@away, @home)
      expect(result[:prediction][:home][:wins]).to eq(1)
      expect(result[:prediction][:away][:wins]).to eq(1)
      expect(result[:prediction][:up_for_grabs][:wins]).to eq(8)
    end

    it "returns the predicted number of points for each team" do
      # away +4
      FactoryBot.create(:wrestler, weight: 125, rank: 2, college: @away)
      # away + 3
      FactoryBot.create(:wrestler, weight: 133, rank: 1, college: @away)
      FactoryBot.create(:wrestler, weight: 133, rank: 2, college: @home)
      # home + 4
      FactoryBot.create(:wrestler, weight: 149, rank: 1, college: @home)
      result = MatchService.preview(@away, @home)

      expect(result[:prediction][:home][:wins]).to eq(1)
      expect(result[:prediction][:away][:wins]).to eq(2)
      expect(result[:prediction][:up_for_grabs][:wins]).to eq(7)

      expect(result[:prediction][:home][:score]).to eq(4)
      expect(result[:prediction][:away][:score]).to eq(7)
      expect(result[:prediction][:up_for_grabs][:score]).to eq(21)
    end
  end
end
