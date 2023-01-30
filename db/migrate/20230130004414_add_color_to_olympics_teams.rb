class AddColorToOlympicsTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :olympics_teams, :color, :string
  end
end
