class CreateTrackComments < ActiveRecord::Migration[7.0]
  def change
    create_table :track_comments do |t|
      t.references :track, null: false, foreign_key: true
      t.string :body
      t.integer :track_minute
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
