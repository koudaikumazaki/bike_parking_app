FactoryBot.define do
  factory :user do
    username { "test_user" }
    email    { "tester@example.com"}
    password { "password" }
  end
end
