class Advocate::ScheduleParser
  attr_accessor :dates, :employees

  def self.parse!(file_path)
    parser = new(file_path)
    Advocate::Employee.destroy_all
    Advocate::Shift.destroy_all
    parser.parse!
  end

  def initialize(file_path)
    @doc = Nokogiri::HTML(File.read(file_path))
  end

  def get(date)
    @shifts[date]
  end

  def parse!
    parse_dates!
    parse_employees!
    parse_shifts!
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
        date = @dates[date_index]
        raw_shift_code = td.text
        next if raw_shift_code == ""
        next if raw_shift_code.include?("PTO")
        next if raw_shift_code.include?("CLED")

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
    @dates = @doc
      .css("#formContentPlaceHolder_myScheduleTable tr.noTop")
      .css(".data")
      .map { |n| n.text }
  end
end
