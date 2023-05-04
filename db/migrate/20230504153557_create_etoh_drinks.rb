class CreateEtohDrinks < ActiveRecord::Migration[7.0]
  def change
    create_table :etoh_drinks do |t|
      t.timestamp :consumed_at
      t.integer :oz
      t.integer :abv

      t.timestamps
    end
  end
end
