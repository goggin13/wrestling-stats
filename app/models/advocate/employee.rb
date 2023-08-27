class Advocate::Employee < ApplicationRecord
  module ShiftLabels
    ALL = [
      DAY = "DAY",
      NIGHT = "NIGHT",
      SWING = "SWING",
    ]
  end

  has_many :shifts, class_name: "Advocate::Shift", foreign_key: "employee_id"

  def self.create_from_full_name(name, role)
    last, first = name.split(", ")
    role = "RN" if role == "LPN"
    role = "RN" if role == "RNR"
    role = "RN" if role == "RN-EXT"
    role = "RN" if role == "RN-LEAD"
    role = "AGCY" if role == "AGCY-INT"
    Advocate::Employee.find_or_create_by!(
      name: name,
      role: role,
      first: first.capitalize,
      last: last.capitalize,
    )
  end

  def update_shift_label!
    counts = Advocate::Shift
      .where(:employee_id => self.id)
      .select(:start, "COUNT(*)")
      .order(count: :desc)
      .group(:start)

    return if counts.length == 0

    self.shift_label = case counts[0].start
      when 7..9
        ShiftLabels::DAY
      when 11..15
        ShiftLabels::SWING
      when 19..23
        ShiftLabels::NIGHT
    end

    save!
  end

  def rn?
    ["LPN", "RN", "AGCY"].include?(role)
  end

  def tech?
    ["TECH", "NCT"].include?(role)
  end

  def full_name
    "#{last.downcase} #{first.downcase}"
  end

  def to_s
    "#{name}:#{role}"
  end
end
