FactoryBot.define do
  factory :event_host do
    name { "MyString" }
    description { "MyText" }
    event { nil }
    user { nil }
    listed_on_page { false }
    event_manager { false }
  end
end
