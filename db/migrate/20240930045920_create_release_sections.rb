class CreateReleaseSections < ActiveRecord::Migration[7.2]
  def change
    create_table :release_sections do |t|
      t.string :title
      t.text :body
      t.integer :position
      t.jsonb :data
      t.references :release, null: false, foreign_key: true

      t.timestamps
    end
  end
end
