class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :slug
      t.text :description
      t.jsonb :metadata
      t.boolean :private
      t.string :playlist_type
      t.datetime :release_date
      t.string :genre
      t.string :custom_genre
      t.integer :likes_count

      t.timestamps
    end
    add_index :playlists, :slug
  end
end
