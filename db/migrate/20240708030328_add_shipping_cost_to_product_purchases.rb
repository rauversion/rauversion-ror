class AddShippingCostToProductPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :product_purchases, :shipping_cost, :decimal
  end
end
