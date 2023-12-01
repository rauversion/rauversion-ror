class AddPositionToTrackPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :track_playlists, :position, :integer
  end
end
