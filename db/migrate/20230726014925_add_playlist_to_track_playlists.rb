class AddPlaylistToTrackPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_reference :track_playlists, :playlist, null: false, foreign_key: true
  end
end
