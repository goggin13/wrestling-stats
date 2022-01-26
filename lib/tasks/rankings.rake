namespace :rankings do
  desc "Scrape Latest Individual and Team Rankings from Intermat"
  task update: :environment do
    WrestlerService.scrape_rankings
  end
end
