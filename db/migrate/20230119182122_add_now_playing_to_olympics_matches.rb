class AddNowPlayingToOlympicsMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :olympics_matches, :now_playing, :boolean, default: false
  end
end
