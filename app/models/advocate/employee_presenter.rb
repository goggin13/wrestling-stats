class Advocate::EmployeePresenter
  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def rns
    return @_rns if defined?(@_rns)

    @_rns = Advocate::Employee
      .where(role: ["RN", "AGCY"])
      .where.not(shift_label: nil)
      .order(role: :DESC, shift_label: :ASC)
      .reject do |e|
        e.shifts
           .where(date: @start_date..@end_date)
           .count < 1

    end.sort_by { |rn| rn.shifts.where(date: @start_date..@end_date).count }.reverse
      .sort_by { |rn| rn.shift_label }.reverse
      .sort_by { |rn| rn.role }.reverse

  end

  def staff_counts
    rns.inject({}) do |acc, employee|
      bucket = if employee.role == "AGCY"
        "AGCY"
      elsif employee.full_time_during?(@start_date, @end_date)
        "FT-RN"
      else
        "PT-RN"
      end

      acc[bucket] ||= {}
      acc[bucket][employee.shift_label] ||= 0
      acc[bucket][employee.shift_label] += 1
      acc
    end
  end

  def hours_breakdown
    result = {
      total: 0,
      full_time_staff: 0,
      part_time_staff: 0,
      agency: 0
    }

    Advocate::Shift
      .where(date: @start_date..@end_date)
      .where("duration > ?", 0)
      .inject(result) do |acc, shift|
        role = shift.employee.role

        if role == "RN"
          acc[:total] += shift.duration
          if shift.employee.full_time_during?(@start_date, @end_date)
            acc[:full_time_staff] += shift.duration
          else
            acc[:part_time_staff] += shift.duration
          end
        elsif role == "AGCY"
          acc[:total] += shift.duration
          acc[:agency] += shift.duration
        end

        acc
      end
  end
end
