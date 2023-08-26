desc "Advocate Tasks"
namespace :advocate do
  desc "import schedule"
  task :import_schedule, [:path] => :environment do |t, args|
    Advocate::ScheduleParser.parse!(args.path)
  end

  desc "Rebuild all Advocate Data"
  task :rebuild, [] => :environment do |t, args|
    puts "deleting employees, shifts"
    Advocate::Employee.destroy_all
    Advocate::Shift.destroy_all
    puts "\tdone"

    Dir.glob("spec/download_fixtures/advocate/archive/*.html") do |file|
      puts file
      Advocate::ScheduleParser.parse!(file)
      puts "\tdone"
    end
  end
end
