require "rails_helper.rb"

describe WrestlerService do
  describe "current_rankings_url" do
    before do
      fixture_path = "spec/download_fixtures/flow_rankings_index.html"
      fixture_data = File.read(fixture_path)
      @flow_rankings_index = fixture_data
    end

    it "downloads the rankings index and gets the current NCAA rankings URL" do
      expect(DownloadService)
        .to receive(:download)
        .with("https://www.flowrestling.org/rankings")
        .and_return(@flow_rankings_index)

      expect(WrestlerService.current_rankings_url).to eq("https://www.flowrestling.org/rankings/10846490-2023-24-ncaa-di-rankings/46726-p4p-carter-starocci")
    end
  end

  describe "ranking_urls_by_weight" do
    before do
      fixture_path = "spec/download_fixtures/flow_p4p_rankings.html"
      fixture_data = File.read(fixture_path)
      @flow_p4p_rankings = fixture_data

      fixture_path = "spec/download_fixtures/flow_rankings_index.html"
      fixture_data = File.read(fixture_path)
      @flow_rankings_index = fixture_data
    end

    it "returns a hash of weights to URLs of rankings" do
      expect(DownloadService)
        .to receive(:download)
        .with("https://www.flowrestling.org/rankings")
        .and_return(@flow_rankings_index)

      expect(DownloadService)
        .to receive(:download)
        .with("https://www.flowrestling.org/rankings/10846490-2023-24-ncaa-di-rankings/46726-p4p-carter-starocci")
        .and_return(@flow_p4p_rankings)

      result = WrestlerService.ranking_urls_by_weight
      root = "https://www.flowrestling.org/rankings/10846490-2023-24-ncaa-di-rankings"

      expect(result[125]).to eq("#{root}/46727-125-anthony-noto")
      expect(result[133]).to eq("#{root}/46728-133-ryan-crookham")
      expect(result[141]).to eq("#{root}/46729-141-real-woods")
      expect(result[149]).to eq("#{root}/46730-149-ridge-lovett")
      expect(result[157]).to eq("#{root}/46731-157-levi-haines")
      expect(result[165]).to eq("#{root}/46732-165-keegan-otoole")
      expect(result[174]).to eq("#{root}/46733-174-carter-starocci")
      expect(result[184]).to eq("#{root}/46734-184-parker-keckeisen")
      expect(result[197]).to eq("#{root}/46735-197-aaron-brooks")
      expect(result[285]).to eq("#{root}/46736-285-greg-kerkvliet")
      expect(result[:tournament]).to eq("#{root}/46737-penn-state")

    end
  end

  describe ".scrape_rankings_for_weight" do
    before do
      fixture_path = "spec/download_fixtures/flow_125_rankings.html"
      fixture_data = File.read(fixture_path)
      @rankings_125_html = fixture_data
      allow(WrestlerService)
        .to receive(:ranking_urls_by_weight)
        .and_return({125 => "https://www.flowrestling.org/rankings/10846490-2023-24-ncaa-di-rankings/46727-125-anthony-noto"})
    end

    it "creates a wrestler record for each ranked wrestler" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      expect do
        WrestlerService.scrape_rankings_for_weight(125)
      end.to change(Wrestler, :count).by(33)
    end

    it "saves the name, rank, college, year and weight of each wrestler" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      WrestlerService.scrape_rankings_for_weight(125)

      wrestler = Wrestler.find_by(name: "Anthony Noto")
      expect(wrestler.college.name).to eq("Lock Haven")
      expect(wrestler.rank).to eq(1)
      expect(wrestler.year).to eq("JR")
      expect(wrestler.weight).to eq(125)
    end

    it "does not create duplicate wrestlers if run twice" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      expect do
        WrestlerService.scrape_rankings_for_weight(125)
        WrestlerService.scrape_rankings_for_weight(125)
      end.to change(Wrestler, :count).by(33)

      expect(Wrestler.where(name: "Anthony Noto").count).to eq(1)
    end

    it "updates a wrestler's rank, college, and weight if they have changed" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      FactoryBot.create(:wrestler,
        name: "Anthony Noto",
        rank: 17,
        college: FactoryBot.create(:college, name:"Rutgers"),
        weight: 133,
        year: "Fr",
      )

      WrestlerService.scrape_rankings_for_weight(125)

      expect(Wrestler.where(name: "Anthony Noto").count).to eq(1)

      wrestler = Wrestler.find_by(name: "Anthony Noto")
      expect(wrestler.college.name).to eq("Lock Haven")
      expect(wrestler.rank).to eq(1)
      expect(wrestler.weight).to eq(125)
      expect(wrestler.year).to eq("JR")
    end

    it "creates a college for a new wrestler" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      expect do
        WrestlerService.scrape_rankings_for_weight(125)
      end.to change(College, :count).by(33)
    end

    it "deletes a wrestler if they are no longer ranked" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      wrestler = FactoryBot.create(:wrestler, name: "Joe Fish", rank: 17, weight: 125)

      WrestlerService.scrape_rankings_for_weight(125)

      expect(Wrestler.where(id: wrestler.id).count).to eq(0)
    end

    it "doesn't set a wrestler's rank to nil if they are in a different weight class" do
      allow(DownloadService).to receive(:download).and_return(@rankings_125_html)
      wrestler = FactoryBot.create(:wrestler, name: "Joe Fish", rank: 17, weight: 133)

      WrestlerService.scrape_rankings_for_weight(125)

      wrestler.reload
      expect(wrestler.rank).to eq(17)
    end
  end

  describe ".scrape_team_dual_rankings" do
    before do
      fixture_path = "spec/download_fixtures/intermat_rankings.html"
      fixture_data = File.read(fixture_path)
      expect(DownloadService)
        .to receive(:download)
        .with("https://intermatwrestle.com/rankings.html/ncaa-di-r9/")
        .and_return(fixture_data)
    end

    it "updates a teams dual meet ranking" do
      college = FactoryBot.create(:college, name: "Cornell")
      expect(college.dual_rank).to eq(nil)

      WrestlerService.scrape_team_dual_rankings

      college.reload
      expect(college.dual_rank).to eq(2)
    end

    it "updates a teams dual meet ranking to nil if they aren't on the list" do
      college = FactoryBot.create(:college, name: "TC3", dual_rank: 1)

      WrestlerService.scrape_team_dual_rankings

      college.reload
      expect(college.dual_rank).to eq(nil)
    end
  end

  describe ".scrape_team_tournament_rankings" do
    before do
      fixture_path = "spec/download_fixtures/flow_team_tournament_rankings.html"
      fixture_data = File.read(fixture_path)
      allow(DownloadService).to receive(:download).and_return(fixture_data)

      allow(WrestlerService)
        .to receive(:ranking_urls_by_weight)
        .and_return({tournament: "https://www.flowrestling.org/rankings/10846490-2023-24-ncaa-di-rankings/46737-penn-state"})
    end

    it "updates a teams tournament ranking" do
      college = FactoryBot.create(:college, name: "Cornell")
      expect(college.tournament_rank).to eq(nil)

      WrestlerService.scrape_team_tournament_rankings

      college.reload
      expect(college.tournament_rank).to eq(2)
    end

    it "updates a teams tournament ranking to nil if they aren't on the list" do
      college = FactoryBot.create(:college, name: "TC3", tournament_rank: 1)

      WrestlerService.scrape_team_tournament_rankings

      college.reload
      expect(college.tournament_rank).to eq(nil)
    end
  end
end
