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
      .where.not(raw_shift_code: "LD-D")
      .reject { |s| s.employee.status == Advocate::Employee::Status::UNKNOWN }

    @rn_shifts = @all_shifts
      .reject { |s| s.employee.role != "RN" }
  end

  def threshold_for(role, date, hour)
    if role == :ect
      ect_thresholds[hour].to_f
    else
      rn_thresholds[hour].to_f
    end
  end

  # of RNs by hour
  # 07:00 7
  # 08:00 7
  # 09:00 8
  # 10:00 8
  # 11:00 9
  # 12:00 9
  # 13:00 9
  # 14:00 9
  # 15:00 10
  # 16:00 10
  # 17:00 10
  # 18:00 10
  # 19:00 10
  # 20:00 10
  # 21:00 9
  # 22:00 9
  # 23:00 8
  # 00:00 8
  # 01:00 8
  # 02:00 8
  # 03:00 7
  # 04:00 7
  # 05:00 7
  # 06:00 7
  def rn_thresholds
    return @_rn_thresholds if defined?(@_rn_thresholds)

    @_rn_thresholds = {}
    (7...9).to_a.each { |h| @_rn_thresholds[h] = 7 }
    (9...11).to_a.each { |h| @_rn_thresholds[h] = 8 }
    (11...15).to_a.each { |h| @_rn_thresholds[h] = 9 }
    (15...21).to_a.each { |h| @_rn_thresholds[h] = 10 }
    (21...23).to_a.each { |h| @_rn_thresholds[h] = 9 }
    (23...24).to_a.each { |h| @_rn_thresholds[h] = 8 }
    (0...3).to_a.each { |h| @_rn_thresholds[h] = 8 }
    (3...7).to_a.each { |h| @_rn_thresholds[h] = 7 }

    @_rn_thresholds
  end

  # 11a-11p: 5
  # 11p-11a: 4
  def ect_thresholds
    return @_ect_thresholds if defined?(@_ect_thresholds)

    @_ect_thresholds = {}
    (7...11).to_a.each { |h| @_ect_thresholds[h] = 4 }
    (11..23).to_a.each { |h| @_ect_thresholds[h] = 5 }
    (23...24).to_a.each { |h| @_ect_thresholds[h] = 4 }
    (0...7).to_a.each { |h| @_ect_thresholds[h] = 4 }

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

  def pct_tally(array)
    grouped_pct_array = array.map { |pct| [pct.floor(-1), 100].min }
    total = grouped_pct_array.length.to_f

    results = {month: {count: 0, pct: 0} }
    grouped_pct_array.tally.inject(results) do |acc, tally|
      pct = [tally[0].floor(-1), 100].min
      count = tally[1]
      acc[pct] = {
        count: count,
        pct: count / total
      }
      acc[:month][:count] += count
      acc[:month][:pct] += count / total

      acc
    end
  end

  def rn_pct_tally
    pct_tally(pct_array)
  end

  def ect_pct_tally
    pct_tally(ect_pct_array)
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
    return 0 if pct_array.length == 0

    [pct_array[pct_array.length - 1], 100].min
  end

  def ect_median_pct
    ect_pct_array[ect_pct_array.length / 2]
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
