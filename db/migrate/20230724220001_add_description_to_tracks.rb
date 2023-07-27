class AddDescriptionToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :description, :text
  end
end
