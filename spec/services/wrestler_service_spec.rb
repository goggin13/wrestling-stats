require "rails_helper.rb"

describe WrestlerService do
  describe ".scrape_rankings_for_weight" do
    before do
      fixture_path = "spec/download_fixtures/intermat_rankings_125.html"
      fixture_data = File.read(fixture_path)
      @rankings_125_html = fixture_data
    end

    it "passes the correct URL to DownloadService" do
      url = "https://intermatwrestle.com/rankings/college/125"
      expect(DownloadService)
        .to receive(:download)
        .with(url)
        .and_return(@rankings_125_html)

      WrestlerService.scrape_rankings_for_weight(125)
    end

    it "creates a wrestler record for each ranked wrestler" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      expect do
        WrestlerService.scrape_rankings_for_weight(125)
      end.to change(Wrestler, :count).by(33)
    end

    it "saves the name, rank, college and weight of each wrestler" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      WrestlerService.scrape_rankings_for_weight(125)

      wrestler = Wrestler.find_by(name: "Nick Suriano")
      expect(wrestler.college.name).to eq("Michigan")
      expect(wrestler.rank).to eq(1)
      expect(wrestler.weight).to eq(125)
    end

    it "does not create duplicate wrestlers if run twice" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      expect do
        WrestlerService.scrape_rankings_for_weight(125)
        WrestlerService.scrape_rankings_for_weight(125)
      end.to change(Wrestler, :count).by(33)

      expect(Wrestler.where(name: "Nick Suriano").count).to eq(1)
    end

    it "updates a wrestler's rank, college, and weight if they have changed" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      FactoryBot.create(:wrestler,
        name: "Nick Suriano",
        rank: 17,
        college: FactoryBot.create(:college, name:"Rutgers"),
        weight: 133
      )

      WrestlerService.scrape_rankings_for_weight(125)

      expect(Wrestler.where(name: "Nick Suriano").count).to eq(1)

      wrestler = Wrestler.find_by(name: "Nick Suriano")
      expect(wrestler.college.name).to eq("Michigan")
      expect(wrestler.rank).to eq(1)
      expect(wrestler.weight).to eq(125)
    end

    it "creates a college for a new wrestler" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      expect do
        WrestlerService.scrape_rankings_for_weight(125)
      end.to change(College, :count).by(33)
    end
  end

  describe ".scrape_team_dual_rankings" do
    before do
      fixture_path = "spec/download_fixtures/intermat_team_dual_rankings.html"
      fixture_data = File.read(fixture_path)
      allow(DownloadService).to receive(:download).and_return(fixture_data)
    end

    it "updates a teams dual meet ranking" do
      college = FactoryBot.create(:college, name: "Cornell")
      expect(college.dual_rank).to eq(nil)

      WrestlerService.scrape_team_dual_rankings

      college.reload
      expect(college.dual_rank).to eq(11)
    end
  end

  describe ".scrape_team_tournament_rankings" do
    before do
      fixture_path = "spec/download_fixtures/intermat_team_tournament_rankings.html"
      fixture_data = File.read(fixture_path)
      allow(DownloadService).to receive(:download).and_return(fixture_data)
    end

    it "updates a teams dual meet ranking" do
      college = FactoryBot.create(:college, name: "Cornell")
      expect(college.tournament_rank).to eq(nil)

      WrestlerService.scrape_team_tournament_rankings

      college.reload
      expect(college.tournament_rank).to eq(9)
    end
  end
end
