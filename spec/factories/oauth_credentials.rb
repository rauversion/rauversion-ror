FactoryBot.define do
  factory :oauth_credential do
    uid { "MyString" }
    token { "MyString" }
    data { "" }
    provider { "MyString" }
    user { nil }
  end
end
