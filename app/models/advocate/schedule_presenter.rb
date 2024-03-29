class Advocate::SchedulePresenter

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @monthly_reporter = Advocate::MonthlyReporter.new(start_date)

    @shifts = Advocate::Shift
      .where(date: start_date..end_date)
      .where.not(raw_shift_code: "ORF")
      .all
      .reject { |s| s.employee.status == Advocate::Employee::Status::UNKNOWN }

    Rails.logger.info "[INFO] Presenting #{start_date}-#{end_date}"
  end

  def dates
    results = @shifts.map(&:date).uniq

    first_sunday = @start_date
    while first_sunday.wday != 0
      first_sunday = first_sunday - 1.day
      results << first_sunday
    end

    results.sort
  end

	def working_on?(date, employee)
    @shifts.select do |shift|
      shift.date == date && shift.employee == employee
    end.length > 0
  end

  def timeline(date)
    return [] unless @monthly_reporter.staffing_grid.has_key?(date)

    @monthly_reporter.staffing_grid[date]
      .transform_keys do |hour|
        (hour * 100).to_s.rjust(4, "0")
    end
  end

  def shifts_for(date)
    todays_shifts = @shifts.select { |s| s.date == date }

    day_shifts = todays_shifts.select { |s| s.start.present? && s.start.to_i > 0 && s.start.to_i <= 9 }
    day_shift_rns = day_shifts.select { |s| s.employee.rn? }
    day_shift_techs = day_shifts.select { |s| s.employee.tech? }
    # day_shift_us = day_shifts.find { |s| s.employee.role == "US" }

    swing_shifts = todays_shifts.select { |s| s.start.present? && s.start.to_i > 9 && s.start.to_i < 19 }
    swing_shift_rns = swing_shifts.select { |s| s.employee.rn? }
    swing_shift_techs = swing_shifts.select { |s| s.employee.tech? }

    night_shifts = todays_shifts.select { |s| s.start.to_i >= 18 }
    night_shift_rns = night_shifts.select { |s| s.employee.rn? }
    night_shift_techs = night_shifts.select { |s| s.employee.tech? }
    # night_shift_us = night_shifts.find { |s| s.employee.role == "US" }

    unsorted = Advocate::Shift
      .joins(:employee)
      .where("advocate_shifts.date" => date)
      .where("advocate_employees.status" => Advocate::Employee::Status::UNKNOWN)
      .all

    orientees = Advocate::Shift
      .where("advocate_shifts.date" => date)
      .where(raw_shift_code: "ORF")
      .all

    {
      day: { us: [], rns: day_shift_rns, techs: day_shift_techs },
      swing: { rns: swing_shift_rns, techs: swing_shift_techs },
      night: { us: [], rns: night_shift_rns, techs: night_shift_techs },
      unsorted: unsorted,
      orientees: orientees
    }
  end
end
