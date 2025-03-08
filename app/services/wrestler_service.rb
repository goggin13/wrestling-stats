class WrestlerService
  FLOW_ROOT = "https://www.flowrestling.org"

  WEIGHTS = [125, 133, 141, 149, 157, 165, 174, 184, 197, 285]

  def self.scrape_rankings
    cached_urls = ranking_urls_by_weight
    WEIGHTS.each do |weight|
      WrestlerService.scrape_rankings_for_weight(weight, cached_urls)
    end
    WrestlerService.scrape_team_tournament_rankings(cached_urls)
  end

  def self.current_rankings_url
    flow_rankings_index_url = "#{FLOW_ROOT}/rankings"
    document = Nokogiri::HTML(DownloadService.download(flow_rankings_index_url))
    link_title = "2024-25 NCAA DI Wrestling Rankings"
    links = document.xpath("//a[contains(., '#{link_title}')]")
    path = links[0]["href"]

    FLOW_ROOT + path
  end

  def self.ranking_urls_by_weight
    doc = Nokogiri::HTML(DownloadService.download(current_rankings_url))

    path = doc.xpath("//a[contains(., 'Team Tournament')]")[0]["href"]
    results = {tournament: FLOW_ROOT + path}

    WEIGHTS.inject(results) do |acc, weight|
      path = doc.xpath("//a[contains(., '#{weight}')]")[0]["href"]
      acc[weight] = FLOW_ROOT + path

      acc
    end
  end

  def self.scrape_rankings_for_weight(weight, cached_urls=nil)
    urls = cached_urls || ranking_urls_by_weight
    url = urls[weight]
    Wrestler.where(weight: weight).destroy_all
    document = Nokogiri::HTML(DownloadService.download(url))
    document.css(".content.ng-star-inserted tr")[1..].each do |tr|
      data = tr.css("td").map { |td| td.content }
      rank, year, name, school, previous = data
      wrestler = Wrestler.find_by(name: name)
      college = College.find_or_create_by_corrected_name(school)
      update_data = {
        name: name,
        rank: rank,
        college: college,
        weight: weight.to_i,
        year: year,
      }

      Rails.logger.info "#{weight}lbs #{rank} #{name}"

      if wrestler
        wrestler.update!(update_data)
      else
        Wrestler.create!(update_data)
      end
    end
  end

  def self.intermat_ncaa_d1_rankings_url
    url = "https://intermatwrestle.com/rankings/ncaadi.html/"

    DownloadService.redirects_to(url)
  end

  def self.scrape_team_tournament_rankings(cached_urls=nil)
    urls = cached_urls || ranking_urls_by_weight
    url = urls[:tournament]
    College.update_all(tournament_rank: nil)
    document = Nokogiri::HTML(DownloadService.download(url))
    document.css(".content.ng-star-inserted tr")[1..].each do |tr|
      data = tr.css("td").map { |td| td.content }
      rank, school, points, previous = data
      Rails.logger.info "Tournament[#{rank}] : #{school}"
      college = College.find_by_corrected_name!(school)
      college.tournament_rank = rank
      college.save!
    end
  end
end
