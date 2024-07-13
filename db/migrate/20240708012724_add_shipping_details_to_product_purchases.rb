class AddShippingDetailsToProductPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :product_purchases, :shipping_address, :jsonb
    add_column :product_purchases, :shipping_name, :string
    add_column :product_purchases, :phone, :string
  end
end
