class AddYearToWrestlers < ActiveRecord::Migration[7.0]
  def change
    add_column :wrestlers, :year, :string
  end
end
