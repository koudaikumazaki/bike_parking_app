FactoryBot.define do
  factory :contact do
    name     { 'tester' }
    email  { 'test_user@example.com' }
    genru   { 'その他' }
    title { '問い合わせ機能のテスト' }
    content { 'テストです' }
  end
end