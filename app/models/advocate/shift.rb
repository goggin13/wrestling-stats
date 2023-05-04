class Advocate::Shift < ApplicationRecord
  belongs_to :employee, class_name: "Advocate::Employee"

  def self.create_from_raw_shift_code(raw_shift_code, date, employee)
    shift = Advocate::Shift.new(
      raw_shift_code: raw_shift_code,
      employee: employee,
      date: DateTime.parse(date),
    )
    shift.parse_shift_code!
    shift.save!

    shift
  end

  def parse_shift_code!
    if raw_shift_code =~ /^\d\d-\d\d/
      self.start = raw_shift_code[0..1]
      self.duration = raw_shift_code[3..4]
    elsif raw_shift_code =~ /^EX\d\d\d\d/
      self.start = raw_shift_code[2..3]
      self.duration = raw_shift_code[4..5]
    elsif raw_shift_code =~ /^OC\d\d-\d\d/
      self.start = raw_shift_code[2..3]
      self.duration = raw_shift_code[5..6]
    elsif raw_shift_code =~ /^CHG\d\d\d\d/
      self.start = raw_shift_code[3..4]
      self.duration = raw_shift_code[5..6]
    end
  end

  def label
    if start.present?
      "#{start}-#{duration}"
    else
      raw_shift_code
    end
  end

  def working_during?(hour)
    if hour >= 7
      (hour >= start) && hour < (start + duration)
    else
      (start + duration > 24) && hour < (start + duration) % 24
    end
  end

  def to_s
    "[#{date}] #{label} <#{employee.to_s}>   ---  #{raw_shift_code}"
  end
end
