require 'csv'

class Advocate::CsvScheduleParser
  def self.parse(path)
    parser = new(path)
    parser.parse!
  end

  def initialize(path)
    rows = CSV.read(path)
    @rows = rows[1...-1] #remove header row, last empty row
  end

  def parse!
    # Sample Row
    # Department: 36102,08/30/2023,,"Edwards, Veronica",RN,CHGPREC,07:00,8.50
    @rows.each do |row|
      _, date, identifier, name, role, shift_code, start_time, duration = row
      employee = Advocate::Employee.create_from_full_name(name, role)
      Advocate::Shift.create!(
        date: Date.strptime(date, "%m/%d/%Y"),
        start: start_time,
        duration: duration,
        employee: employee,
        raw_shift_code: shift_code
      )
    end
  end
end
