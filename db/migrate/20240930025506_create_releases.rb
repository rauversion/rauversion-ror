class CreateReleases < ActiveRecord::Migration[7.2]
  def change
    create_table :releases do |t|
      t.references :playlist, null: false, foreign_key: true
      t.string :slug
      t.string :title
      t.jsonb :config

      t.timestamps
    end
  end
end
