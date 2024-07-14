FactoryBot.define do
  factory :product_shipping do
    product { nil }
    country { "MyString" }
    base_cost { "9.99" }
    additional_cost { "9.99" }
  end
end
