class Advocate::MonthlyReporter
  ALL_HOUR_LABELS = ((7..23).to_a + (0..6).to_a).inject({}) do |acc, hour|
    acc[hour] = (hour * 100).to_s.rjust(4, "0")
    acc
  end

  def initialize(month)
    @start_day = month.beginning_of_month
    @end_day = month.end_of_month
    @shifts = Advocate::Shift
      .where("date >= ? and date <= ?", @start_day, @end_day)
      .where.not(raw_shift_code: "ORF")
      .reject { |s| s.employee.status == Advocate::Employee::Status::UNKNOWN }
  end

  def threshold_for(date, hour)
    # Fri, Sat, Sun
    if [5, 6, 0].include?(date.wday)
      weekend_thresholds[hour].to_f
    else
      thresholds[hour].to_f
    end
  end

  # D0700-0900  6
  # D0900-1100  Fr-Sun: 7, 8
  # D1100-1300  Fr-Sun: 9, 10
  # D1300-1500  Fr-Sun: 9, 10
  # E1500-1900  Fr-Sun: 9, 10
  # E1900-2100  8
  # E2100-2300  7
  # N2300-0100  7
  # NT0100-0300 7
  # NT0300-0700 Fr-Sun: 6, 5
  def thresholds
    return @_thresholds if defined?(@_thresholds)

    @_thresholds = {}
    (7...9).to_a.each { |h| @_thresholds[h] = 6 }
    (9...11).to_a.each { |h| @_thresholds[h] = 8 }
    (11...19).to_a.each { |h| @_thresholds[h] = 10 }
    (19...21).to_a.each { |h| @_thresholds[h] = 8 }
    (21...24).to_a.each { |h| @_thresholds[h] = 7 }
    (0...3).to_a.each { |h| @_thresholds[h] = 7 }
    (3...7).to_a.each { |h| @_thresholds[h] = 5 }

    @_thresholds
  end

  def weekend_thresholds
    return @_weekend_thresholds if defined?(@_weekend_thresholds)

    @_weekend_thresholds = thresholds.dup

    (9...11).to_a.each { |h| @_weekend_thresholds[h] = 7 }
    (11...19).to_a.each { |h| @_weekend_thresholds[h] = 9 }
    (3...7).to_a.each { |h| @_weekend_thresholds[h] = 6 }

    @_thresholds
  end

  def hours_by_employee_status
    return @_hours_by_employee_status if defined?(@_hours_by_employee_status)

    result = {
      total: 0,
      full_time: {hours: 0, pct: 0},
      agency: {hours: 0, pct: 0},
      part_time: {hours: 0, pct: 0},
    }

    @shifts.inject(result) do |acc, shift|

      if shift.employee.status == "FullTime"
        acc[:full_time][:hours] += shift.duration
        acc[:total] += shift.duration
      elsif shift.employee.status == "PartTime"
        acc[:part_time][:hours] += shift.duration
        acc[:total] += shift.duration
      elsif shift.employee.status == "Agency"
        acc[:agency][:hours] += shift.duration
        acc[:total] += shift.duration
      end

      acc
    end

    [:full_time, :part_time, :agency].each do |status|
      next if result[status] == 0
      result[status][:pct] = (result[status][:hours] / result[:total].to_f * 100).round(2)
    end

    @_hours_by_employee_status = result
  end

  def staffing_grid
    return @_staffing_grid if defined?(@_staffing_grid)

    @_staffing_grid = {}

    (@start_day..@end_day).each do |day|
      @_staffing_grid[day] = {}
      hours = (7..23).to_a + (0..6).to_a
      hours.each do |hour|
        @_staffing_grid[day][hour] = {rns: 0, pct: 0}
      end
    end

    @shifts.each do |shift|
      starting_hour = shift.start
      ending_hour = starting_hour + shift.duration
      (starting_hour...ending_hour).each do |hour|
        hour = hour % 24
        @_staffing_grid[shift.date][hour][:rns] += 1
        threshold = threshold_for(shift.date, hour)
        pct = @_staffing_grid[shift.date][hour][:rns] / threshold
        @_staffing_grid[shift.date][hour][:pct] = (pct.round(2) * 100).to_i
      end
    end

    @_staffing_grid
  end

  def median_pct
    pcts = []
    staffing_grid.each do |day, hours|
      hours.each do |hour, data|
        if data[:pct] > 0
          pcts << data[:pct]
        end
      end
    end

    pcts.sort[pcts.length / 2]
  end

  def full_timers
    employees_by_status(Advocate::Employee::Status::FULL_TIME)
  end

  def part_timers
    employees_by_status(Advocate::Employee::Status::PART_TIME)
  end

  def agency
    employees_by_status(Advocate::Employee::Status::AGENCY)
  end

  def orientees
    employee_ids = Advocate::Shift
      .where("date >= ? and date <= ?", @start_day, @end_day)
      .where(raw_shift_code: "ORF")
      .map(&:employee_id)

    Advocate::Employee
      .where(id: employee_ids)
      .where(status: Advocate::Employee::Status::FULL_TIME)
      .order(:last)
      .all
  end

  def unknown_employees
    employee_ids = Advocate::Shift
      .where("date >= ? and date <= ?", @start_day, @end_day)
      .map(&:employee_id)

    Advocate::Employee
      .where(id: employee_ids)
      .where(status: Advocate::Employee::Status::UNKNOWN)
      .order(:last)
      .all
  end

  def employees_by_status(status)
    employee_ids = @shifts.map(&:employee_id)
    Advocate::Employee
      .where(id: employee_ids)
      .where(status: status)
      .order(:last)
      .all
  end
end