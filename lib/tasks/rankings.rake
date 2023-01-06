namespace :rankings do
  desc "Scrape Latest Individual and Team Rankings from Intermat"
  task update: :environment do
    puts "Scraping Rankings"
    WrestlerService.scrape_rankings
    puts "Completed"
  end
end
