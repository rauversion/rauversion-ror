class AddPaymentIntentIdToProductPurchases < ActiveRecord::Migration[7.1]
  def change
    add_column :product_purchases, :payment_intent_id, :string
  end
end
