FactoryBot.define do
  factory :connected_account do
    user { nil }
    state { "MyString" }
    parent { nil }
  end
end
