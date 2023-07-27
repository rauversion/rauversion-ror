FactoryBot.define do
  factory :event_schedule do
    event { nil }
    start_date { "2023-07-26 18:14:21" }
    end_date { "2023-07-26 18:14:21" }
    schedule_type { "MyString" }
    name { "MyString" }
    description { "MyString" }
  end
end
