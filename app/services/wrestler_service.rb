class WrestlerService
  WEIGHTS = [125, 133, 141, 149, 157, 165, 174, 184, 197, 285]

  def self.scrape_rankings
    WEIGHTS.each do |weight|
      WrestlerService.scrape_rankings_for_weight(weight)
    end
  end

  def self.scrape_rankings_for_weight(weight)
    url = url_for_weight(weight)
    document = Nokogiri::HTML(DownloadService.download(url))
    document.css(".oddrow, .evenrow").each do |tr|
      data = tr.content.split(/(\n|\t)+/).compact
      name = data[4]
      wrestler = Wrestler.find_by(name: name)
      update_data = {
        name: name,
        rank: data[2],
        college: data[6],
        weight: weight.to_i,
      }

      if wrestler
        wrestler.update!(update_data)
      else
        Wrestler.create!(update_data)
      end
    end
  end

  def self.url_for_weight(weight)
    if weight == 285
      weight = "Hwt"
    end

    "https://intermatwrestle.com/rankings/college/#{weight}"
  end
end
