class Advocate::StaffingCalculator
  GOAL_RN_STAFF = {
    7 => 6, 8 => 6,
    9 => 8, 10 => 8,
    11 => 10, 12 => 10, 13 => 10, 14 => 10, 15 => 10, 16 => 10, 17 => 10, 18 => 10, 19 => 10, 20 => 10,
    21 => 8, 22 => 8,
    23 => 7, 24 => 7, 0 => 7, 1 => 7, 2 => 7,
    3 => 6, 4 => 6, 5 => 6, 6 => 6
  }

  GOAL_RN_BUCKET_LABELS = {
    "0700-0900": 6,
    "0900-1100": 8,
    "1100-2100": 10,
    "2100-2300": 8,
    "2300-0300": 7,
    "0300-0700": 6,
  }

  def initialize(day)
    @day = day
    @shifts = Advocate::Shift
      .where(date: @day)
      .where.not(start: nil)
      .where.not(duration: nil)
  end

  def counts
    results = {}
    hours = (7..23).to_a + (0..6).to_a
    (hours).each do |hour|
      results[hour] = @shifts.inject(rns: 0, techs: 0) do |acc, shift|
        if shift.working_during?(hour)
          if shift.employee.rn?
            acc[:rns] += 1
          elsif shift.employee.tech?
            acc[:techs] += 1
          end
        end

        acc
      end
    end

    hours.each do |hour|
      goal_rns = GOAL_RN_STAFF[hour]
      actual_rns = results[hour][:rns]
      results[hour][:rn_pct] = (actual_rns / goal_rns.to_f * 100).round(2)
    end

    results
  end

  def write_records
    Advocate::StaffingHour.where(date: @day).delete_all
    counts.each do |hour, results|
      Advocate::StaffingHour.create!(
        date: @day,
        hour: hour,
        rns: results[:rns],
        rn_pct: results[:rn_pct],
        techs: results[:techs]
      )
    end
  end

  def self.rebuild_staffing_hours
    Advocate::StaffingHour.delete_all
    start_day = Advocate::Shift.minimum(:date)
    end_day = Advocate::Shift.maximum(:date)
    (start_day..end_day).each do |day|
      puts "processing #{day}"
      Advocate::StaffingCalculator.new(day).write_records
    end
  end
end
