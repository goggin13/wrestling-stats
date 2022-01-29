class WrestlerService
  WEIGHTS = [125, 133, 141, 149, 157, 165, 174, 184, 197, 285]

  def self.scrape_rankings
    WEIGHTS.each do |weight|
      WrestlerService.scrape_rankings_for_weight(weight)
    end
    WrestlerService.scrape_team_dual_rankings
    WrestlerService.scrape_team_tournament_rankings
  end

  def self.scrape_rankings_for_weight(weight)
    Wrestler.where(weight: weight).update_all(rank: nil)
    url = url_for_weight(weight)
    document = Nokogiri::HTML(DownloadService.download(url))
    document.css(".oddrow, .evenrow").each do |tr|
      data = tr.content.split(/(\n|\t)+/).compact
      name = data[4]
      wrestler = Wrestler.find_by(name: name)
      college = College.find_or_create_by!(name: data[6])
      update_data = {
        name: name,
        rank: data[2],
        college: college,
        weight: weight.to_i,
      }

      if wrestler
        wrestler.update!(update_data)
      else
        Wrestler.create!(update_data)
      end
    end
  end

  def self.scrape_team_dual_rankings
    College.update_all(dual_rank: nil)
    url = "https://intermatwrestle.com/rankings/college/Team2"
    document = Nokogiri::HTML(DownloadService.download(url))
    document.css(".oddrow, .evenrow").each do |tr|
      data = tr.content.split(/(\n|\t)+/).compact
      dual_rank = data[2].to_i
      college = College.find_or_create_by!(name: data[4])
      college.dual_rank = dual_rank
      college.save!
    end
  end

  def self.scrape_team_tournament_rankings
    College.update_all(tournament_rank: nil)
    url = "https://intermatwrestle.com/rankings/college/Team"
    document = Nokogiri::HTML(DownloadService.download(url))
    document.css(".oddrow, .evenrow").each do |tr|
      data = tr.content.split(/(\n|\t)+/).compact
      tournament_rank = data[2].to_i
      college = College.find_or_create_by!(name: data[4])
      college.tournament_rank = tournament_rank
      college.save!
    end
  end

  def self.url_for_weight(weight)
    if weight == 285
      weight = "Hwt"
    end

    "https://intermatwrestle.com/rankings/college/#{weight}"
  end
end
