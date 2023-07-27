class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.jsonb :body
      t.jsonb :settings
      t.boolean :private
      t.text :excerpt
      t.string :title
      t.string :slug
      t.string :state

      t.timestamps
    end
    add_index :posts, :slug
  end
end
