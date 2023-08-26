class Advocate::ScheduleParser
  attr_accessor :dates, :employees, :start_year, :end_year
  IGNORED_SHIFTS = ["PTO", "CLED", "UNV", "ABS", "BEREV", "SWTCH", "SICK"]

  def self.parse!(file_path)
    parser = new(file_path)
    parser.parse!
  end

  def initialize(file_path)
    @doc = Nokogiri::HTML(File.read(file_path))
    regex_results = file_path.match(/.*schedule_(?<start>\d\d\d\d).*#(?<end>\d\d\d\d)/)
    @start_year = regex_results["start"]
    @end_year = regex_results["end"]
  end

  def get(date)
    @shifts[date]
  end

  def parse!
    parse_dates!
    delete_current_shifts_in_range!
    parse_employees!
    parse_shifts!
    Advocate::Employee.all.each { |e| e.update_shift_label! }
  end

  def delete_current_shifts_in_range!
    Advocate::Shift
      .where("date >= ? AND date <= ?", @dates.first, @dates.last)
      .destroy_all
  end

  def parse_employees!
    @employees = @doc
      .css("#formContentPlaceHolder_orgUnitScheduleHeaderTable tr.mh")
      .map do |tr|
        tds = tr.css("td")
        name = tds[0].text
        role = tds[1].text
        if name.present?
          Advocate::Employee.create_from_full_name(name, role)
        end
      end.compact

    @employees << Advocate::Employee.create_from_full_name("Goggin, Matt", "RN")
  end

  def parse_shifts!
    @shifts = {}
    my_tr = @doc.css("#formContentPlaceHolder_myScheduleTable tr.hl")[0]
    all_trs = @doc.css("#formContentPlaceHolder_orgUnitScheduleDiv tr").select do |tr|
      (tr.attr("class") =~ /noTop/).nil?
    end
    shift_trs = all_trs.to_a + [my_tr]

    unless shift_trs.length == @employees.length
      msg = "Parsing Error: mismatch in shifts-employees: #{shift_trs.length} != #{@employees.length}"
      puts msg
      raise msg
    end

    shift_trs.each_with_index do |tr, employee_index|

      employee = employees[employee_index]

      tr.css("td").each_with_index do |td, date_index|
        if td.attr("title").present?
          next if td.attr("title").downcase.include?("[alternate]")
        end

        date = @dates[date_index]
        raw_shift_code = td.text
        next if raw_shift_code == ""
        next if IGNORED_SHIFTS.any? { |label| raw_shift_code.include?(label) }

        raw_shift_code = raw_shift_code.gsub("¤", "")
        @shifts[date] ||= []
        @shifts[date] << Advocate::Shift.create_from_raw_shift_code(
          raw_shift_code,
          date,
          employee,
        )
      end
    end
  end

  def parse_dates!
    # a series of strings mm/dd
    @dates = @doc
      .css("#formContentPlaceHolder_myScheduleTable tr.noTop")
      .css(".data")
      .map { |n| n.text }

    # add year to end of date string and parse
    # account for files that cross a year boundary
    @dates = dates.map do |date_string|
      date_string = if @start_year != @end_year && date_string[0..1] == "01"
        "#{date_string}/#{@end_year}"
      else
        "#{date_string}/#{@start_year}"
      end

      Date.strptime(date_string, "%m/%d/%Y")
    end
  end
end
