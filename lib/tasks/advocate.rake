desc "Advocate Tasks"
namespace :advocate do
  desc "import schedule"
  task :import_schedule, [:path] => :environment do |t, args|
    Advocate::ScheduleParser.parse!(args.path)
  end

  desc "Rebuild all Advocate Data"
  task :rebuild, [] => :environment do |t, args|
    puts "deleting employees, shifts"
    Advocate::Employee.delete_all
    Advocate::Shift.delete_all
    Advocate::StaffingHour.delete_all
    puts "\tdone"

    Dir.glob("spec/download_fixtures/advocate/archive/*.html") do |file|
      puts file
      Advocate::ScheduleParser.parse!(file)
      puts "\tdone"
    end

    Advocate::StaffingCalculator.rebuild_staffing_hours
  end

  desc "Rebuild staffing hours table from all dates"
  task :rebuild_staffing_hours , [] => :environment do |t, args|
    Advocate::StaffingCalculator.rebuild_staffing_hours
  end
end
