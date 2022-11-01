class AddUrlToColleges < ActiveRecord::Migration[7.0]
  def change
    add_column :colleges, :url, :string
  end
end
