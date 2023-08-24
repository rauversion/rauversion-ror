FactoryBot.define do
  factory :track do
    sequence(:title) { |n| "title-#{n}" }
    private { false }
    caption { "MyString" }
    user { nil }
    likes_count { 1 }
    reposts_count { 1 }
    tags { [] }
  end
end
