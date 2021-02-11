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
require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user) }

  it "名前、メールアドレス、パスワードがあれば有効な状態である" do
    expect(user).to be_valid
  end

  it "名前がなければ無効な状態である" do
    user.username = nil
    user.valid?
    expect(user.errors[:username]).to include("を入力してください")
  end

  it "メールアドレスがなければ無効な状態である" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "パスワードがなければ無効な状態である" do
    user.password = nil
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "メールアドレスが重複していれば無効な状態である" do
    create(:user, email: "tester@example.com")
    user = build(:user, email: "tester@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  it "パスワードが６文字未満でエラーが出る" do
    user.password = 'a' * 5
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end

  it "パスワードが６文字以上で有効な状態である" do
    user.password = user.password_confirmation = 'a' * 6
    expect(user).to be_valid
  end

  it 'メールアドレスは全て小文字で保存される' do
    user.email = 'TESTER@EXAMPLE.COM'
    user.save!
    expect(user.reload.email).to eq 'tester@example.com'
  end

  it "ユーザー名が30文字以下で有効な状態である" do
    user.username = 'a' * 30
    expect(user).to be_valid
  end

  it "ユーザー名が31文字以上でエラーが出る" do
    user.username = 'a' * 31
    user.valid?
    expect(user.errors[:username]).to include("は30文字以内で入力してください")
  end

  it "メールアドレスが正しいフォーマットで入力されていることを確認する" do
    addresses = %w[user@foo,com
                   user_at_foo.org
                   example.user@foo.foo@bar_baz.com
                   foo@bar+baz.com
                   foo@bar..com]

    addresses.each do |invalid_address|
      expect(build(:user, email: invalid_address)).to be_invalid
    end
  end

  it "メールアドレスが100文字以下で有効な状態である" do
    user.email = "#{'a' * 88}@example.com"
    expect(user).to be_valid
  end

  it "メールアドレスが101文字以上でエラーが出る" do
    user.email = "#{'a' * 89}@example.com"
    user.valid?
    expect(user.errors[:email]).to include("は100文字以内で入力してください")
  end
end
