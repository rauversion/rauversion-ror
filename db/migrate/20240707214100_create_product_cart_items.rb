class CreateProductCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :product_cart_items do |t|
      t.references :product_cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
