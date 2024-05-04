class CreateSpotlights < ActiveRecord::Migration[7.0]
  def change
    create_table :spotlights do |t|
      t.references :user, null: false, foreign_key: true
      t.references :spotlightable, polymorphic: true, null: false
      t.integer :position
      t.timestamps
    end
  end
end
