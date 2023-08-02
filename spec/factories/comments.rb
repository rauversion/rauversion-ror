FactoryBot.define do
  factory :comment do
    commentable { nil }
    user { nil }
    body { "MyText" }
    parent_id { 1 }
  end
end
