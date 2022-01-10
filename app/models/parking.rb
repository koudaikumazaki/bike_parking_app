class Parking < ApplicationRecord
  include Paginate
  mount_uploader :image, ImageUploader

  belongs_to :user
  has_many :favorites, dependent: :destroy

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  validates :name, :fee, :price, :address, :capacity, :user_id, :latitude, :longitude, :time, presence: true
  validates :name, length: { maximum: 30 }
  validates :fee, numericality: { only_integer: true }
  validates :price, numericality: { only_integer: true }
  validates :address, length: { maximum: 100 }
  validates :capacity, numericality: { only_integer: true }
  validates :others, length: { maximum: 150 }
  validates :time, numericality: { only_integer: true }

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
