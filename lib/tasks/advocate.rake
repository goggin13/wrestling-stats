desc "Advocate Tasks"
namespace :advocate do
  desc "import schedule"
  task :import_schedule, [:path] => :environment do |t, args|
    Advocate::CsvScheduleParser.parse(args.path, Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
  end

  desc "Rebuild all Advocate Data"
  task :rebuild, [] => :environment do |t, args|
    puts "deleting employees, shifts"
    Advocate::Employee.delete_all
    Advocate::Shift.delete_all
    puts "\tdone"

    Dir.glob("spec/download_fixtures/advocate/csv/*.csv") do |file|
      puts file
      Advocate::CsvScheduleParser.parse(file, Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
      puts "\tdone"
    end
  end
end
