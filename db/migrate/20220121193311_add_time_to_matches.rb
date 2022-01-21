class AddTimeToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :time, :datetime
  end
end
