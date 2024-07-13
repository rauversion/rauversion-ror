class AddShippingCostToProductPurchaseItems < ActiveRecord::Migration[7.1]
  def change
    add_column :product_purchase_items, :shipping_cost, :decimal
  end
end
