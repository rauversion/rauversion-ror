class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.string :sku
      t.string :category
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.references :playlist, null: true, foreign_key: true
      t.timestamps
    end
  end
end
