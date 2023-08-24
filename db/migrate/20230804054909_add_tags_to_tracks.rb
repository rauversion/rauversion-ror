class AddTagsToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :tags, :string, array: true, default: []
    add_index :tracks, :tags, using: "gin"
  end
end
