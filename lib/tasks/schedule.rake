namespace :schedule do
  desc "Ingest array from app/models/raw_schedule.rb"
  task ingest: :environment do
    RawSchedule.ingest
  end
end
