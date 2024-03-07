require 'csv'

class Advocate::CsvScheduleParser
  STATUS_MAP = {
    1 => Advocate::Employee::Status::FULL_TIME,
    2 => Advocate::Employee::Status::PART_TIME,
    3 => Advocate::Employee::Status::AGENCY,
    4 => Advocate::Employee::Status::UNKNOWN,
  }

  def self.parse(path, employee_path)
    parser = new(path, employee_path)
    parser.delete_existing_shifts!
    parser.parse_schedule!
  end

  def self.parse_orientees_from_nonproductive_file!(path, employee_path)
    parser = new(path, employee_path)
    parser.delete_existing_orientation_shifts!
    parser.parse_orientees_from_non_productive_file!
  end

  def initialize(path, employee_path)
    @employee_path = employee_path
    if File.exists?(@employee_path)
      @employees = YAML::load(File.open(@employee_path)) || {}
    else
      @employees = {}
    end
    rows = CSV.read(path)
    @rows = rows[1...-1] #remove header row, last empty row
    @dates = @rows
      .map { |row| Date.strptime(row[1], "%m/%d/%Y") }
      .sort
  end

  def write_employees!
    @employees = @employees.sort_by { |name, _| name }.to_h
    File.open(@employee_path, "w") { |file| file.write(@employees.to_yaml) }
  end

  def delete_existing_shifts!
    Advocate::Shift
      .where("date >= ? AND date <= ?", @dates.min, @dates.max)
      .where.not(raw_shift_code: "ORF")
      .destroy_all
  end

  def delete_existing_orientation_shifts!
    Advocate::Shift
      .where("date >= ? AND date <= ?", @dates.min, @dates.max)
      .where(raw_shift_code: "ORF")
      .destroy_all
  end

  def parse_orientees_from_non_productive_file!
    parse_schedule! { |shift_code| shift_code != "ORF" }
  end

  def parse_schedule!
    # Sample Row
    # Department: 36102,08/30/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
    @rows.each do |row|
      _, date, identifier, full_name, role, shift_code, start_time, duration = row
      shift_code = "ORF" if shift_code == "ORFNG"
      next unless role == "RN" || role == "LPN" || role == "ECT"
      next if block_given? && yield(shift_code)

      full_name = full_name.gsub(/[[:space:]]/, " ").downcase
      status = status_for_employee(full_name, row)

      employee = Advocate::Employee.create_from_full_name(full_name, role, status)
      Advocate::Shift.create!(
        date: Date.strptime(date, "%m/%d/%Y"),
        start: start_time,
        duration: duration,
        employee: employee,
        raw_shift_code: shift_code
      )

      write_employees!
    end
  end

  def status_for_employee(name, row)
    if @employees.has_key?(name)
      @employees[name]
    else
      key = 0
      while !STATUS_MAP.keys.include?(key)
        puts row[1..].join(",")
        puts "Employee type for #{name}:"
        STATUS_MAP.each { |k,v| puts "\t#{k}: #{v}" }
        key = STDIN.gets.chomp.to_i
      end
        status = STATUS_MAP[key]
      @employees[name] = status
      puts "\t saved #{name}: #{status}"

      status
    end
  end
end
