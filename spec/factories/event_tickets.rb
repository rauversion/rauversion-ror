FactoryBot.define do
  factory :event_ticket do
    title { "MyString" }
    price { "9.99" }
    early_bird_price { "9.99" }
    standard_price { "9.99" }
    qty { 1 }
    selling_start { "2023-07-26 18:20:42" }
    selling_end { "2023-07-26 18:20:42" }
    short_description { "MyString" }
    settings { "" }
    event { nil }
    inserted_at { "2023-07-26 18:20:42" }
    updated_at { "2023-07-26 18:20:42" }
  end
end
