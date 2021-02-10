# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(191)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(191)
#  email                  :string(191)      default(""), not null
#  encrypted_password     :string(191)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(191)
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(191)
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string(191)
#  unlock_token           :string(191)
#  username               :string(191)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  has_many :parkings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_parkings, through: :favorites, source: :parking
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  validates :username, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 100 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  GUEST_EMAIL = 'guest@example.com'.freeze

  # 簡単ログイン用、ユーザー作成
  def self.guest
    find_or_create_by!(email: GUEST_EMAIL) do |user|
      user.username = "guest_user"
      user.password = "fhjdashfuirhagldjfkajlsf"
      user.confirmed_at = Time.zone.now
    end
  end
end
