class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :parkings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_parkings, through: :favorites, source: :parking

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  # 簡単ログイン用、ユーザー作成
  def self.guest
    find_or_create_by!(email: ENV['GUEST_EMAIL']) do |user|
      user.name = "guest_user"
      user.password = ENV['GUEST_PASSWORD']
      user.confirmed_at = Time.zone.now
    end
  end
end
