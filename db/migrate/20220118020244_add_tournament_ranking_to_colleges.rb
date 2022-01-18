class AddTournamentRankingToColleges < ActiveRecord::Migration[7.0]
  def change
    add_column :colleges, :tournament_rank, :integer
  end
end
