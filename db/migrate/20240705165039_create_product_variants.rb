class CreateProductVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :product_variants do |t|
      t.string :name
      t.decimal :price
      t.integer :stock_quantity
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
