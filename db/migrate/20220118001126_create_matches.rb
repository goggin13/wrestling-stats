class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.date :date, null: false
      t.integer :home_team_id, null: false, foreign_key: true
      t.integer :away_team_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
