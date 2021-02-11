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
class Parking < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :favorites, dependent: :destroy
  # geocoded_by :address
  # after_validation :geocode
  validates :name, presence: true, length: { maximum: 30 }
  validates :address, presence: true, length: { maximum: 100 }
  validates :fee, presence: true, length: { maximum: 20 }
  validates :capacity, presence: true, length: { maximum: 20 }
  validates :others, length: { maximum: 150 }
  validates :user_id, presence: true

  # def favorite_user(user_id)
  #   favorites.find_by(user_id: user_id)
  # end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
