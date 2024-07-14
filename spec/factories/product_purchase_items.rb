FactoryBot.define do
  factory :product_purchase_item do
    product_purchase { nil }
    product { nil }
    quantity { 1 }
    price { "9.99" }
  end
end
