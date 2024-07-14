class AddTrackingCodeToProductPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :product_purchases, :tracking_code, :string
  end
end
