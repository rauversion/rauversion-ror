class AddPodcastToTracks < ActiveRecord::Migration[7.1]
  def change
    add_column :tracks, :podcast, :boolean
  end
end
