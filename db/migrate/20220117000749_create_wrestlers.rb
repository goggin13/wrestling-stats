class CreateWrestlers < ActiveRecord::Migration[7.0]
  def change
    create_table :wrestlers do |t|
      t.string :name
      t.string :college
      t.integer :rank

      t.timestamps
    end
  end
end
