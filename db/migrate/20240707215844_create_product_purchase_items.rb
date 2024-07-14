class CreateProductPurchaseItems < ActiveRecord::Migration[7.1]
  def change
    create_table :product_purchase_items do |t|
      t.references :product_purchase, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
