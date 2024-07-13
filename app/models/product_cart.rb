class ProductCart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :product_cart_items, dependent: :destroy
  has_many :products, through: :product_cart_items

  def add_product(product, quantity = 1)
    current_item = product_cart_items.find_by(product: product)
    if current_item
      current_item.quantity += quantity
    else
      current_item = product_cart_items.build(product: product, quantity: quantity)
    end
    current_item.save
  end

  def total_price
    product_cart_items.sum { |item| item.total_price }
  end
end