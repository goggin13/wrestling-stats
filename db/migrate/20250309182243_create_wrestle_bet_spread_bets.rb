class CreateWrestleBetSpreadBets < ActiveRecord::Migration[7.0]
  def change
    create_table :wrestle_bet_spread_bets do |t|
      t.integer :match_id
      t.references :user, null: false, foreign_key: true
      t.string :wager

      t.timestamps
    end
  end
end
