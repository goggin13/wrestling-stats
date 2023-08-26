class Advocate::SchedulePresenter

  def initialize(start_date, end_date)
    Rails.logger.info "Presenting #{start_date}-#{end_date}"
    # @shifts = Advocate::Shift.where(date: @start_date..@end_date).all
    @shifts = Advocate::Shift.all

    Rails.logger.info "Presenting #{dates}"
  end

  def dates
    @shifts.map(&:date).sort.uniq
  end

	def working_on?(date, employee)
    date = DateTime.parse(date) if date.is_a?(String)
    @shifts.select do |shift|
      shift.date == date && shift.employee == employee
    end.length > 0
  end

  def timeline(date)
    date = DateTime.parse(date) if date.is_a?(String)
    todays_shifts = @shifts.select do |s|
      s.date == date && s.start.present?
    end

    results = {}
    hours = (7..23).to_a + (0..6).to_a
    (hours).each do |hour|
      results[hour] = todays_shifts.inject(rn: 0, tech: 0) do |acc, shift|
        if shift.working_during?(hour)
          if shift.employee.rn?
            acc[:rn] += 1
          elsif shift.employee.tech?
            acc[:tech] += 1
          end
        end

        acc
      end
    end

    results.transform_keys do |hour|
      (hour * 100).to_s.rjust(4, "0")
    end
  end

  def shift_count_for_graph(date)
    timeline = timeline(date).to_a
    grouped_results = {}

    previous_hour = nil
    previous_count = nil

    timeline.each do |hour, count|
      if previous_hour.nil?
        previous_hour = hour
        previous_count = count
      elsif count != previous_count
        new_key = previous_hour + "-" + hour
        grouped_results[new_key] = previous_count
        previous_hour = hour
        previous_count = count
      end
    end

    grouped_results[previous_hour + "-0700"] = previous_count

    grouped_results
  end

  def shifts_for(date)
    date = DateTime.parse(date) if date.is_a?(String)
    todays_shifts = @shifts.select { |s| s.date == date }

    day_shifts = todays_shifts.select { |s| s.start.present? && s.start.to_i > 0 && s.start.to_i <= 9 }
    day_shift_rns = day_shifts.select { |s| s.employee.rn? }
    day_shift_techs = day_shifts.select { |s| s.employee.tech? }
    day_shift_us = day_shifts.find { |s| s.employee.role == "US" }

    swing_shifts = todays_shifts.select { |s| s.start.present? && s.start.to_i > 9 && s.start.to_i < 19 }
    swing_shift_rns = swing_shifts.select { |s| s.employee.rn? }
    swing_shift_techs = swing_shifts.select { |s| s.employee.tech? }

    night_shifts = todays_shifts.select { |s| s.start.to_i >= 18 }
    night_shift_rns = night_shifts.select { |s| s.employee.rn? }
    night_shift_techs = night_shifts.select { |s| s.employee.tech? }
    night_shift_us = night_shifts.find { |s| s.employee.role == "US" }

    unsorted = todays_shifts.select { |s| s.start.nil? }

    {
      day: { us: day_shift_us, rns: day_shift_rns, techs: day_shift_techs },
      swing: { rns: swing_shift_rns, techs: swing_shift_techs },
      night: { us: night_shift_us, rns: night_shift_rns, techs: night_shift_techs },
      unsorted: unsorted
    }
  end
end
