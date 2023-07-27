class CreateTracks < ActiveRecord::Migration[7.0]
  def change
    create_table :tracks do |t|
      t.string :title
      t.boolean :private
      t.string :slug
      t.string :caption
      t.references :user, null: false, foreign_key: true
      t.jsonb :notification_settings
      t.jsonb :metadata
      t.integer :likes_count
      t.integer :reposts_count
      t.string :state
      t.jsonb :tags

      t.timestamps
    end
    add_index :tracks, :slug
  end
end
