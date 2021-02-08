FactoryBot.define do
  factory :favorite do
    association :parking
    association :user
  end
end
