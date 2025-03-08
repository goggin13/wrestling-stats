namespace :wrestling do
  desc "Scrape Latest Individual and Team Rankings from Intermat"
  task rankings: :environment do
    puts "Scraping Rankings"
    WrestlerService.scrape_rankings
    puts "Completed"
  end

  desc "Ingest array from app/models/raw_schedule.rb"
  task reset_schedule: :environment do
    RawSchedule.ingest
  end

  desc "update all"
  task update_all: :environment do
    RawSchedule.ingest
    WrestlerService.scrape_rankings
  end
end
