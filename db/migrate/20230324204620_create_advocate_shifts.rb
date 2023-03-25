class CreateAdvocateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :advocate_shifts do |t|
      t.date :date, null: false
      t.integer :start, null: true
      t.integer :duration, null: true
      t.integer :employee_id, null: false, foreign_key: true, references: :advocate_employee
      t.string :raw_shift_code, null: false

      t.timestamps
    end
  end
end
