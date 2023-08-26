class CreateAdvocateStaffingHours < ActiveRecord::Migration[7.0]
  def change
    create_table :advocate_staffing_hours do |t|
      t.date :date, null: false
      t.integer :hour, null: false
      t.integer :rns, null: false
      t.integer :techs
      t.float :rn_pct

      t.timestamps
    end
  end
end
