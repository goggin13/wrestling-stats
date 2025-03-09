class CreateWrestleBetMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :wrestle_bet_matches do |t|
      t.integer :weight
      t.boolean :started, default: false
      t.integer :home_wrestler_id
      t.integer :away_wrestler_id
      t.integer :home_score
      t.integer :away_score
      t.integer :tournament_id

      t.timestamps
    end
  end
end
