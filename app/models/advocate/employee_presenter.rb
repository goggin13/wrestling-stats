class Advocate::EmployeePresenter
  REQUIRED_SHIFTS_FOR_FULL_TIME = 8

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
         .count < REQUIRED_SHIFTS_FOR_FULL_TIME
      end
  end

  def staff_counts
    rns.inject({}) do |acc, employee|
      acc[employee.role] ||= {}
      acc[employee.role][employee.shift_label] ||= 0
      acc[employee.role][employee.shift_label] += 1
      acc
    end
  end

  def hours_breakdown
    result = {
      total: 0,
      staff: 0,
      agency: 0
    }

    Advocate::Shift
      .where(date: @start_date..@end_date)
      .where("duration > ?", 0)
      .inject(result) do |acc, shift|
        role = shift.employee.role

        if role == "RN"
          acc[:total] += shift.duration
          acc[:staff] += shift.duration
        elsif role == "AGCY"
          acc[:total] += shift.duration
          acc[:agency] += shift.duration
        end

        acc
      end
  end
end
