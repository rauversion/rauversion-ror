FactoryBot.define do
  factory :user do
    email { "MyString" }
    username { "MyString" }
    label { false }
    support_link { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    country { "MyString" }
    city { "MyString" }
    bio { "MyText" }
    settings { "" }
    role { "MyString" }
  end
end
