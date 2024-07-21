FactoryBot.define do
  factory :coupon do
    user { nil }
    code { "MyString" }
    discount_type { "9.99" }
    expires_at { "2024-07-21 12:15:04" }
    stripe_id { "MyString" }
  end
end
