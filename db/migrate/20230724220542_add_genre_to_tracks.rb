class AddGenreToTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :tracks, :genre, :string
  end
end
