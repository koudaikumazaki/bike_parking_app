# == Schema Information
#
# Table name: parkings
#
#  id         :bigint           not null, primary key
#  address    :text(65535)
#  capacity   :string(191)
#  fee        :string(191)
#  image      :string(191)
#  latitude   :float(24)
#  longitude  :float(24)
#  name       :text(65535)
#  others     :text(65535)
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
    capacity { '５台' }
    others   { '特になし' }
    association :user
  end
end
