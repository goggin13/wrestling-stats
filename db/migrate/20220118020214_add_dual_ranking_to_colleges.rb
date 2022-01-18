class AddDualRankingToColleges < ActiveRecord::Migration[7.0]
  def change
    add_column :colleges, :dual_rank, :integer
  end
end
