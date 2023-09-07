desc "Advocate Tasks"
namespace :advocate do
  desc "import schedule"
  task :import_schedule, [:path] => :environment do |t, args|
    Advocate::CsvScheduleParser.parse(args.path, "spec/download_fixtures/advocate/employees.yml")
  end

  desc "Rebuild all Advocate Data"
  task :rebuild, [] => :environment do |t, args|
    puts "deleting employees, shifts"
    Advocate::Employee.delete_all
    Advocate::Shift.delete_all
    puts "\tdone"

    Dir.glob("spec/download_fixtures/advocate/csv/*.csv") do |file|
      puts file
      Advocate::CsvScheduleParser.parse(file, "spec/download_fixtures/advocate/employees.yml")
      puts "\tdone"
    end
  end
end
