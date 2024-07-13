FactoryBot.define do
  factory :product_purchase do
    user { nil }
    total_amount { "9.99" }
    status { "MyString" }
    stripe_session_id { "MyString" }
  end
end
