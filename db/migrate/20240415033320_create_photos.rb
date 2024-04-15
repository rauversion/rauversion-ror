class CreatePhotos < ActiveRecord::Migration[7.0]
  def change
    create_table :photos do |t|
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.string "tags", default: [], array: true
      t.timestamps
    end
  end
end
