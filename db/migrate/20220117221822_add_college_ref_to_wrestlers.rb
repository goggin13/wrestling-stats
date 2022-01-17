class AddCollegeRefToWrestlers < ActiveRecord::Migration[7.0]
  def change
    add_reference :wrestlers, :college, null: false, foreign_key: true
  end
end
