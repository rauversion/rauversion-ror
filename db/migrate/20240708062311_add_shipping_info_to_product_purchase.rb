class AddShippingInfoToProductPurchase < ActiveRecord::Migration[7.1]
  def change
    add_column :product_purchases, :shipping_status, :string
    add_index :product_purchases, :shipping_status
  end
end
