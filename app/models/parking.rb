# == Schema Information
#
# Table name: parkings
#
#  id         :bigint           not null, primary key
#  address    :text(65535)
#  approval   :integer
#  capacity   :string(191)
#  fee        :string(191)
#  image      :string(191)
#  latitude   :float(24)
#  longitude  :float(24)
#  name       :text(65535)
#  others     :text(65535)
#  price      :bigint
#  time       :string(191)
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
  attr_accessor :distance
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :favorites, dependent: :destroy
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  validates :name, presence: true, length: { maximum: 30 }
  validates :fee, presence: true, length: { maximum: 20 }
  validates :price, presence: true, length: { maximum: 20 }
  validates :address, presence: true, length: { maximum: 100 }
  validates :capacity, presence: true, length: { maximum: 20 }
  validates :others, length: { maximum: 150 }
  validates :user_id, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :time, presence: true, length: { maximum: 20 }
  enum approval:{
    approval:1,
  }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  class << self
    def within_box(distance, latitude, longitude)
      distance = distance
      center_point = [latitude, longitude]
      box = Geocoder::Calculations.bounding_box(center_point, distance)
      self.within_bounding_box(box)
    end
  end
end
