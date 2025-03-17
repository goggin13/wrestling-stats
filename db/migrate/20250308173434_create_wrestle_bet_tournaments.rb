class CreateWrestleBetTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :wrestle_bet_tournaments do |t|
      t.string :name
      t.integer :current_match_id

      t.timestamps
    end
  end
end
