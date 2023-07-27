FactoryBot.define do
  factory :track_comment do
    track { nil }
    body { "MyString" }
    track_minute { 1 }
    user { nil }
  end
end
