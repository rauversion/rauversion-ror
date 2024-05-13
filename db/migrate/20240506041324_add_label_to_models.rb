class AddLabelToModels < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :label_id, :integer
    add_index :tracks, :label_id

    add_column :playlists, :label_id, :integer
    add_index :playlists, :label_id
  end
end
