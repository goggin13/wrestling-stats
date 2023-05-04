class Advocate::Employee < ApplicationRecord

  def self.create_from_full_name(name, role)
    last, first = name.split(", ")
    Advocate::Employee.create!(
      name: name,
      role: role,
      first: first.capitalize,
      last: last.capitalize,
    )
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
