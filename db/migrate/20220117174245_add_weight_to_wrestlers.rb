class AddWeightToWrestlers < ActiveRecord::Migration[7.0]
  def change
    add_column :wrestlers, :weight, :integer
  end
end
