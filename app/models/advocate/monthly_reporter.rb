class Advocate::MonthlyReporter
  ALL_HOUR_LABELS = ((7..23).to_a + (0..6).to_a).inject({}) do |acc, hour|
    acc[hour] = (hour * 100).to_s.rjust(4, "0")
    acc
  end

  def initialize(month)
    @start_day = month.beginning_of_month
    @end_day = month.end_of_month
    @all_shifts = Advocate::Shift
      .where("date >= ? and date <= ?", @start_day, @end_day)
      .where.not(raw_shift_code: "ORF")
      .reject { |s| s.employee.status == Advocate::Employee::Status::UNKNOWN }

    @rn_shifts = @all_shifts
      .reject { |s| s.employee.role != "RN" }
  end

  def threshold_for(role, date, hour)
    if role == :ect
      ect_thresholds[hour].to_f
    # Fri, Sat, Sun
    elsif [5, 6, 0].include?(date.wday)
      rn_weekend_thresholds[hour].to_f
    else
      rn_thresholds[hour].to_f
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
  def rn_thresholds
    return @_rn_thresholds if defined?(@_rn_thresholds)

    @_rn_thresholds = {}
    (7...9).to_a.each { |h| @_rn_thresholds[h] = 6 }
    (9...11).to_a.each { |h| @_rn_thresholds[h] = 8 }
    (11...19).to_a.each { |h| @_rn_thresholds[h] = 10 }
    (19...21).to_a.each { |h| @_rn_thresholds[h] = 8 }
    (21...24).to_a.each { |h| @_rn_thresholds[h] = 7 }
    (0...3).to_a.each { |h| @_rn_thresholds[h] = 7 }
    (3...7).to_a.each { |h| @_rn_thresholds[h] = 5 }

    @_rn_thresholds
  end

  def rn_weekend_thresholds
    return @_rn_weekend_thresholds if defined?(@_rn_weekend_thresholds)

    @_rn_weekend_thresholds = rn_thresholds.dup

    (9...11).to_a.each { |h| @_rn_weekend_thresholds[h] = 7 }
    (11...19).to_a.each { |h| @_rn_weekend_thresholds[h] = 9 }
    (3...7).to_a.each { |h| @_rn_weekend_thresholds[h] = 6 }

    @_rn_weekend_thresholds
  end

  # Day shift
  #   0700-0900 4 => floor techs: 2, triage tech: 1, vitals tech: 1
  #   0900-2300 5 => floor techs: 3, triage tech: 1, vitals tech: 1, fast track: 1
  #   2300-0300 4 => floor techs: 2, triage tech: 1, fast track: 1
  #   0300-0700 3 => floor techs: 2, triage tech: 1
  def ect_thresholds
    return @_ect_thresholds if defined?(@_ect_thresholds)

    @_ect_thresholds = {}
    (7...9).to_a.each { |h| @_ect_thresholds[h] = 4 }
    (9...23).to_a.each { |h| @_ect_thresholds[h] = 6 }
    (23...24).to_a.each { |h| @_ect_thresholds[h] = 4 }
    (0...3).to_a.each { |h| @_ect_thresholds[h] = 4 }
    (3...7).to_a.each { |h| @_ect_thresholds[h] = 3 }

    @_ect_thresholds
  end

  def hours_by_employee_status
    return @_hours_by_employee_status if defined?(@_hours_by_employee_status)

    result = {
      total: 0,
      full_time: {hours: 0, pct: 0},
      agency: {hours: 0, pct: 0},
      part_time: {hours: 0, pct: 0},
    }

    @rn_shifts.inject(result) do |acc, shift|

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

  def _initialize_staffing_grid
    grid = {}

    (@start_day..@end_day).each do |day|
      grid[day] = {}
      hours = (7..23).to_a + (0..6).to_a
      hours.each do |hour|
        grid[day][hour] = {
          rn: {count: 0, pct: 0},
          ect: {count: 0, pct: 0},
        }
      end
    end

    grid
  end

  def staffing_grid
    return @_staffing_grid if defined?(@_staffing_grid)

    @_staffing_grid = _initialize_staffing_grid

    @all_shifts.each do |shift|
      role = if shift.employee.role == "RN"
        :rn
      elsif shift.employee.role == "ECT"
        :ect
      else
        raise "Unexpected role in staffing grid: #{employee.role}"
      end

      starting_hour = shift.start
      ending_hour = starting_hour + shift.duration

      (starting_hour...ending_hour).each do |hour|
        hour = hour % 24
        data_for_hour = @_staffing_grid[shift.date][hour][role]
        data_for_hour[:count] += 1
        threshold = threshold_for(role, shift.date, hour)
        pct = data_for_hour[:count] / threshold
        data_for_hour[:pct] = (pct.round(2) * 100).to_i
      end
    end

    @_staffing_grid
  end

  def pct_array
    return @_pcts if defined?(@_pcts)

    pcts = []
    staffing_grid.each do |day, hours|
      hours.each do |hour, data|
        if data[:rn][:pct] > 0
          pcts << data[:rn][:pct]
        end
      end
    end

    @_pcts = pcts.sort
  end

  def ect_pct_array
    return @_ect_pcts if defined?(@_ect_pcts)

    ect_pcts = []
    staffing_grid.each do |day, hours|
      hours.each do |hour, data|
        if data[:ect][:pct] > 0
          ect_pcts << data[:ect][:pct]
        end
      end
    end

    if ect_pcts.length == 0
      ect_pcts = [0]
    end

    @_ect_pcts = ect_pcts.sort
  end

  def min_pct
    pct_array[0]
  end

  def q1_pct
    pct_array[pct_array.length / 4]
  end

  def median_pct
    pct_array[pct_array.length / 2]
  end

  def q3_pct
    pct_array[pct_array.length / 4 * 3]
  end

  def max_pct
    [pct_array[pct_array.length - 1], 100].min
  end

  def ect_median_pct
    [ect_pct_array[ect_pct_array.length - 1], 100].min
  end

  def ect_min_pct
    ect_pct_array[0]
  end

  def ect_q1_pct
    ect_pct_array[ect_pct_array.length / 4]
  end

  def ect_q3_pct
    ect_pct_array[ect_pct_array.length / 4 * 3]
  end

  def ect_max_pct
    [ect_pct_array[ect_pct_array.length - 1], 100].min
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
    all_orientee_ids = Advocate::Shift
      .where("date >= ? and date <= ?", @start_day, @end_day)
      .where(raw_shift_code: "ORF")
      .map(&:employee_id)

    full_time_ids = full_timers.map(&:id)
    orientee_ids = all_orientee_ids - full_time_ids

    Advocate::Employee
      .where(id: orientee_ids)
      .where(status: Advocate::Employee::Status::FULL_TIME)
      .order(:last)
      .select { |e| e.rn? }
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

  def full_time_by_shift_label
    full_timers.inject({}) do |acc, employee|
      acc[employee.shift_label] ||= []
      acc[employee.shift_label] << employee
      acc
    end
  end

  def employees_by_status(status)
    employee_ids = @rn_shifts.map(&:employee_id)
    Advocate::Employee
      .where(id: employee_ids)
      .where(status: status)
      .order(:last)
      .all
  end
end
