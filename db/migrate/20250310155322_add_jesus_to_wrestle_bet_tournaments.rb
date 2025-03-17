class AddJesusToWrestleBetTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :wrestle_bet_tournaments, :jesus, :integer, default: 0
    add_column :wrestle_bet_tournaments, :exposure, :integer, default: 0
    add_column :wrestle_bet_tournaments, :challenges, :integer, default: 0
  end
end
