class CreatePreviewCards < ActiveRecord::Migration[7.0]
  def change
    create_table :preview_cards do |t|
      t.string :url
      t.string :title
      t.text :description
      t.string :type
      t.string :author_name
      t.string :author_url
      t.text :html
      t.string :image

      t.timestamps
    end
  end
end
