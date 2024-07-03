desc "Advocate Tasks"
namespace :advocate do
  desc "import most recent schedule and orientees"
  task :import, [] => :environment do |t, args|
    non_productive_path = Dir
      .glob("advocate_data/csv/*_show_non_productive_true.csv")
      .max_by {|f| File.mtime(f)}

    productive_path = Dir
      .glob("advocate_data/csv/*_show_non_productive_false.csv")
      .max_by {|f| File.mtime(f)}

    puts "Parsing productive file"
    Advocate::CsvScheduleParser.parse(
      productive_path,
      Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH
    )
    puts "\tDone"

    puts "Parsing orientee file"
    Advocate::CsvScheduleParser.parse_orientees_from_nonproductive_file!(
      non_productive_path,
      Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH
    )
    puts "\tDone"

    puts "Cleaning up"
    Advocate::Employee.post_import_data_cleaning
    puts "\tDone"
  end

  desc "import schedule"
  task :import_schedule, [:path] => :environment do |t, args|
    Advocate::CsvScheduleParser.parse(args.path, Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH)
    Advocate::Employee.post_import_data_cleaning
  end

  desc "import orientees"
  task :import_orientees, [:path] => :environment do |t, args|
    Advocate::CsvScheduleParser.parse_orientees_from_nonproductive_file!(
      args.path,
      Advocate::Employee::EMPLOYEE_STATUS_FILE_PATH
    )
  end

  desc "find days"
  task :find_days, [] => :environment do |t, args|
    minimum = 3
    start_date = Date.new(2024, 5, 1)
    end_date = Date.new(2024, 5, 31)

    me = Advocate::Employee.where(last: "goggin").first!

    employees = [
      "ahmad",
      "cervantes",
      "edwards",
      # "stachnik",
      "maciha"
    ].map do |last|
      Advocate::Employee.where(last: last).first!
    end

    employee_ids = employees.map(&:id) + [me.id]

    options = (start_date..end_date).inject({}) do |acc, date|
      shifts = Advocate::Shift.where(date: date, employee_id: employee_ids)
      working_employees = shifts.map(&:employee)
      if !working_employees.include?(me)
        available_employees = employees - working_employees
        acc[date] = {
          count: available_employees.length,
          shifts: shifts,
          names: available_employees.map(&:last).sort.join(","),
        }
      end

      acc
    end

    options.each do |date, option|
      next unless option[:count] >= minimum
      puts "#{date.strftime("%a %m/%d")} (#{option[:count]}) - #{option[:names]}"
    end
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

    Advocate::Employee.post_import_data_cleaning
  end
end
