desc "Advocate Tasks"
namespace :advocate do
  desc "import schedule"
  task :import_schedule, [:path] => :environment do |t, args|
    Advocate::ScheduleParser.parse!(args.path)
  end
end
