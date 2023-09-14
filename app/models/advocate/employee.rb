class Advocate::Employee < ApplicationRecord
  EMPLOYEE_STATUS_FILE_PATH = "advocate_data/employees.yml"

  module ShiftLabels
    ALL = [
      DAY = "DAY",
      NIGHT = "NIGHT",
      SWING = "SWING",
    ]
  end

  module Status
    ALL = [
      FULL_TIME = "FullTime",
      PART_TIME = "PartTime",
      AGENCY = "Agency",
      UNKNOWN = "Unknown",
    ]
  end

  has_many :shifts, class_name: "Advocate::Shift", foreign_key: "employee_id"

  def self.update_shift_labels
    all.each { |e| e.update_shift_label! }
  end

  def self.create_from_full_name(full_name, role, status)
    last, first = full_name.split(", ")
    role = "RN" if role == "LPN"
    Advocate::Employee.find_or_create_by!(
      name: full_name.downcase,
      role: role,
      status: status,
      first: first.downcase,
      last: last.downcase,
    )
  end

  def self.post_import_processing
    post_import_data_cleaning
    update_shift_labels
  end

  def self.post_import_data_cleaning
    # Quentin was clocked for a couple shifts prior to orientation.
    # Leaving these in causes him to be counted as a full time employee prior to
    # being off orientation
    Advocate::Employee.where(first: "quentin").first!
      .shifts.where("date < '9/1/2023'").where.not(raw_shift_code: "ORF")
      .destroy_all
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

  def short_name
    "#{first.capitalize} #{last.upcase[0]}"
  end

  def to_s
    "#{name}:#{role}"
  end
end
