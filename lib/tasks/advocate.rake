desc "Advocate Tasks"
namespace :advocate do
  desc "import schedule"
  task :import_schedule, [:path] => :environment do |t, args|
    Advocate::CsvScheduleParser.parse(args.path, Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
  end

  desc "import orientees"
  task :import_orientees, [:path] => :environment do |t, args|
    Advocate::CsvScheduleParser.parse_orientees_from_nonproductive_file!(
      args.path,
      Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH
    )
  end

  desc "Rebuild all Advocate Data"
  task :rebuild, [] => :environment do |t, args|
    puts "deleting employees, shifts"
    Advocate::Employee.delete_all
    Advocate::Shift.delete_all
    puts "\tdone"

    Dir.glob("advocate_data/csv/*productive_only.csv") do |file|
      puts file
      Advocate::CsvScheduleParser.parse(file, Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
      puts "\tdone"
    end

    Dir.glob("advocate_data/csv/*nonproductive.csv") do |file|
      puts file
      Advocate::CsvScheduleParser.parse_orientees_from_nonproductive_file!(
        file,
        Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH
      )
      puts "\tdone"
    end
  end
end
