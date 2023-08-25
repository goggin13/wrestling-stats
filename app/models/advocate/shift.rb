class Advocate::Shift < ApplicationRecord
  belongs_to :employee, class_name: "Advocate::Employee"

  def self.create_from_raw_shift_code(raw_shift_code, date, employee)
    date = DateTime.parse(date)
    shift = Advocate::Shift.where(date: date, employee: employee).first

    if shift.present?
      shift.raw_shift_code = raw_shift_code
    else
      shift = Advocate::Shift.new(
        raw_shift_code: raw_shift_code, employee: employee, date: date
      )
    end
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
    elsif raw_shift_code =~ /^EX\d\d\-\d\d/
      self.start = raw_shift_code[2..3]
      self.duration = raw_shift_code[5..6]
    elsif raw_shift_code =~ /^OC\d\d-\d\d/
      self.start = raw_shift_code[2..3]
      self.duration = raw_shift_code[5..6]
    elsif raw_shift_code =~ /^CHG\d\d\d\d/
      self.start = raw_shift_code[3..4]
      self.duration = raw_shift_code[5..6]
    elsif raw_shift_code == "[CHG]" || raw_shift_code == "[TRIAGE]"
      parse_charge_triage_shift!
    elsif raw_shift_code == "[PREC]"
      parse_preceptor_shift!
    end
  end

  def parse_preceptor_shift!
    if employee.first == "Emma"
      self.start = 7
      self.duration = 12
    elsif employee.first == "Stephany"
      self.start = 7
      self.duration = 12
    elsif employee.first == "Yvonne"
      self.start = 19
      self.duration = 12
    end
  end

  def parse_charge_triage_shift!
    if employee.first == "Yazen"
      self.start = 19
      self.duration = 12
    elsif employee.first == "Ashley"
      self.start = 19
      self.duration = 12
    elsif employee.first == "Gabrielle"
      self.start = 19
      self.duration = 12
    elsif employee.first == "Erin"
      self.start = 19
      self.duration = 12
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
