class CreateTrackPlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :track_playlists do |t|
      t.references :track, null: false, foreign_key: true

      t.timestamps
    end
  end
end
