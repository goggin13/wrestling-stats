class CreateAdvocateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :advocate_employees do |t|
      t.string :name
      t.string :first
      t.string :last
      t.string :role

      t.timestamps
    end
  end
end
