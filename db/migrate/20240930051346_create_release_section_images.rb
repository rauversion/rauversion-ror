class CreateReleaseSectionImages < ActiveRecord::Migration[7.2]
  def change
    create_table :release_section_images do |t|
      t.string :caption
      t.integer :order
      t.references :release_section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
