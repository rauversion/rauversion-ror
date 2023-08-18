FactoryBot.define do
  factory :user do
    first_name { "User Name" }
    last_name { "User Name" }
    password { "123456" }
    password_confirmation {"123456"}
    sequence(:username) {|n| "user-#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
  end
end
