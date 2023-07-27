FactoryBot.define do
  factory :track do
    title { "MyString" }
    private { false }
    slug { "MyString" }
    caption { "MyString" }
    user { nil }
    notification_settings { "" }
    metadata { "" }
    likes_count { 1 }
    reposts_count { 1 }
    state { "MyString" }
    tags { "" }
  end
end
