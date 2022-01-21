class AddWatchOnToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :watch_on, :string
  end
end
