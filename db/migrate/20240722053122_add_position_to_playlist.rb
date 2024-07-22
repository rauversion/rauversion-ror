class AddPositionToPlaylist < ActiveRecord::Migration[7.1]
  def change
    add_column :playlists, :editor_choice_position, :integer
  end
end
