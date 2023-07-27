FactoryBot.define do
  factory :event_recording do
    type { "" }
    title { "MyString" }
    description { "MyText" }
    iframe { "MyText" }
    properties { "" }
    position { 1 }
    event { nil }
  end
end
