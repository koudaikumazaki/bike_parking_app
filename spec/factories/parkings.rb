# == Schema Information
#
# Table name: parkings
#
#  id         :bigint           not null, primary key
#  address    :text(65535)
#  approval   :integer
#  capacity   :integer
#  fee        :integer
#  image      :string(191)
#  latitude   :float(24)
#  longitude  :float(24)
#  name       :text(65535)
#  others     :text(65535)
#  price      :integer
#  time       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_parkings_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :parking do
    name     { 'parking' }
    address  { 'address' }
    fee      { '200円' }
    time      { '30分' }
    capacity { '５台' }
    others   { '特になし' }
    latitude { '35.6812362' }
    longitude { '139.7649361' }
    price { 400 }
    approval { 'approval' }
    association :user
  end
end
