FactoryBot.define do
  factory :parking_form, class: "::Parkings::Form" do
    name     { 'parking' }
    address  { 'address' }
    fee      { 200 }
    time      { 30 }
    capacity { 5 }
    others   { '特になし' }
    latitude { '35.6812362' }
    longitude { '139.7649361' }
    fee_per_hour { 400 }
    approval { true }
    association :user
  end
end