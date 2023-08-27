class Advocate::StaffingHour < ApplicationRecord
  ALL_HOUR_LABELS = ((7..23).to_a + (0..6).to_a).inject({}) do |acc, hour|
    acc[hour] = (hour * 100).to_s.rjust(4, "0")
    acc
  end

  def hour_label
    hour_label = (hour * 100).to_s.rjust(4, "0")
  end

  def time_label
    "#{date} #{hour_label}"
  end
end
