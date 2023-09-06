class DropTableAdvocateStaffingHours < ActiveRecord::Migration[7.0]
  def change
    drop_table :advocate_staffing_hours
  end
end
