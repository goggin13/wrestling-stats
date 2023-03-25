class Advocate::SchedulePresenter
  def initialize
    @shifts = Advocate::Shift.all
  end

  def dates
    Advocate::Shift.select(:date).order("date ASC").map(&:date).uniq
  end

  def shifts_for(date)
    date = DateTime.parse(date) if date.is_a?(String)
    todays_shifts = @shifts.select { |s| s.date == date }

    day_shifts = todays_shifts.select { |s| s.start.present? && s.start.to_i > 0 && s.start.to_i <= 9 }
    day_shift_rns = day_shifts.select { |s| ["LPN", "RN", "AGCY"].include?(s.employee.role) }
    day_shift_techs = day_shifts.select { |s| ["TECH", "NCT"].include?(s.employee.role) }
    day_shift_us = day_shifts.find { |s| s.employee.role == "US" }

    swing_shifts = todays_shifts.select { |s| s.start.present? && s.start.to_i > 9 && s.start.to_i < 19 }
    swing_shift_rns = swing_shifts.select { |s| ["LPN", "RN", "AGCY"].include?(s.employee.role) }
    swing_shift_techs = swing_shifts.select { |s| ["TECH", "NCT"].include?(s.employee.role) }

    night_shifts = todays_shifts.select { |s| s.start.to_i >= 18 }
    night_shift_rns = night_shifts.select { |s| ["LPN", "RN", "AGCY"].include?(s.employee.role) }
    night_shift_techs = night_shifts.select { |s| ["TECH", "NCT"].include?(s.employee.role) }
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

# unsorted = shifts.select { |s| s.start.empty? }
#
# day_shifts = shifts.select { |s| s.start.present? && s.start.to_i > 0 && s.start.to_i <= 9 }
# day_shift_RNs = day_shifts.select { |s| ["RN", "AGCY"].include?(s.employee.role) }
# day_shift_techs = day_shifts.select { |s| s.employee.role == "TECH" }
# day_shift_us = day_shifts.find { |s| s.employee.role == "US" }
#
# swing_shifts = shifts.select { |s| s.start.present? && s.start.to_i > 9 && s.start.to_i < 19 }
# swing_shift_RNs = swing_shifts.select { |s| ["RN", "AGCY"].include?(s.employee.role) }
# swing_shift_techs = swing_shifts.select { |s| s.employee.role == "TECH" }
#
# night_shifts = shifts.select { |s| s.start.to_i >= 18 }
# night_shift_RNs = night_shifts.select { |s| ["RN", "AGCY"].include?(s.employee.role) }
# night_shift_techs = night_shifts.select { |s| s.employee.role == "TECH" }
# night_shift_us = night_shifts.find { |s| s.employee.role == "US" }
#
# puts "Day Shift"
# puts day_shift_us
# puts day_shift_RNs
# puts day_shift_techs
#
# puts "\nSwing"
# puts swing_shift_RNs
# puts swing_shift_techs
#
# puts "\nNight Shift"
# puts night_shift_us
# puts night_shift_RNs
# puts night_shift_techs
#
# puts "\nAlso starring"
# puts unsorted
# shift = shifts[0]
