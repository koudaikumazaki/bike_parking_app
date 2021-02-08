FactoryBot.define do
  factory :user do
    username { "test_user" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }
    password_confirmation { password }
  end
end
