FactoryBot.define do
  factory :parking do
    name     { 'parking' }
    address  { 'address' }
    fee      { '200円' }
    capacity { '５台' }
    others   { '特になし' }
    association :user
  end
end
