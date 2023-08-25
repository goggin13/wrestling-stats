class AddShiftLabelToAdvocateEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :advocate_employees, :shift_label, :string
  end
end
