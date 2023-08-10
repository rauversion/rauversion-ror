class AddTagsToPlaylists < ActiveRecord::Migration[7.0]
  def change
    add_column :playlists, :tags, :string, array: true, default: []
    add_index  :playlists, :tags, using: 'gin'
  end
end
