class CreateOlympicsMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :olympics_matches do |t|
      t.integer :bout_number, null: false
      t.integer :team_1_id, null: false, references: :olympics_team
      t.integer :team_2_id, null: false, references: :olympics_team
      t.integer :winning_team_id, null: true, references: :olympics_team
      t.string :event, null: false
      t.integer :bp_cups_remaining, null: true

      t.timestamps
    end
  end
end
