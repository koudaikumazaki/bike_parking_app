# == Schema Information
#
# Table name: parkings
#
#  id         :bigint           not null, primary key
#  address    :text(65535)
#  approval   :boolean          default(FALSE)
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
class Parking < ApplicationRecord
  include Paginate
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :favorites, dependent: :destroy

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  validates :name, :fee, :price, :address, :capacity, :user_id, :latitude, :longitude, :time, presence: true
  validates :name, length: { maximum: 30 }
  validates :fee, length: { maximum: 20 }
  validates :price, length: { maximum: 20 }
  validates :address, length: { maximum: 100 }
  validates :capacity, length: { maximum: 20 }
  validates :others, length: { maximum: 150 }
  validates :time, length: { maximum: 20 }

  scope :approval, -> { where(approval: true) }

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.within_box(distance, latitude, longitude)
    center_point = [latitude, longitude]
    box = Geocoder::Calculations.bounding_box(center_point, distance)
    self.within_bounding_box(box)
  end
end
