class AddSpreadToWrestleBetMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :wrestle_bet_matches, :spread, :float
  end
end
