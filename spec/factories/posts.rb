FactoryBot.define do
  factory :post do
    user { nil }
    body { "" }
    settings { "" }
    private { false }
    excerpt { "MyText" }
    title { "MyString" }
    slug { "MyString" }
    state { "MyString" }
  end
end
