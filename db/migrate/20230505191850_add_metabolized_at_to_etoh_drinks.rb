class AddMetabolizedAtToEtohDrinks < ActiveRecord::Migration[7.0]
  def change
    add_column :etoh_drinks, :metabolized_at, :timestamp
  end
end
