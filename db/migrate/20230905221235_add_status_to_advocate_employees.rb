class AddStatusToAdvocateEmployees < ActiveRecord::Migration[7.0]
  def change
    add_column :advocate_employees, :status, :string
  end
end
