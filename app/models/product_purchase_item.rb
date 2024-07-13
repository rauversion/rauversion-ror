class ProductPurchaseItem < ApplicationRecord
  belongs_to :product_purchase
  belongs_to :product

  def total_price_with_shipping
    (price * quantity) + shipping_cost
  end
end