FactoryBot.define do
  factory :product_variant do
    name { "MyString" }
    price { "9.99" }
    stock_quantity { 1 }
    product { nil }
  end
end
