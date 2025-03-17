class CreateWrestleBetPropBets < ActiveRecord::Migration[7.0]
  def change
    create_table :wrestle_bet_prop_bets do |t|
      t.integer :tournament_id
      t.references :user, null: false, foreign_key: true
      t.integer :jesus
      t.integer :exposure
      t.integer :challenges

      t.timestamps
    end
  end
end
