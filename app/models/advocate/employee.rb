class Advocate::Employee < ApplicationRecord
  self.table_name = "advocate_employees"

  def self.create_from_full_name(name, role)
    last, first = name.split(", ")
    Advocate::Employee.create!(
      name: name,
      role: role,
      first: first.capitalize,
      last: last.capitalize,
    )
  end

  def to_s
    "#{name}:#{role}"
  end
end
