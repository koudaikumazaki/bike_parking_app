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
require 'rails_helper'

RSpec.describe Parking, type: :model do

  let(:parking) { create(:parking) }

  it "駐輪場名、駐輪料金、駐輪台数、投稿者名、緯度、経度が存在すれば投稿できる" do
    parking.others = nil
    expect(parking).to be_valid
  end

  it "駐輪場名が存在しない場合投稿が失敗する" do
    parking.name = nil
    parking.valid?
    expect(parking.errors[:name]).to include("を入力してください")
  end

  it "駐輪場名が30文字以下の場合投稿できる" do
    parking.name = 'a' * 30
    expect(parking).to be_valid
  end

  it "駐輪場名が31文字以上の場合投稿が失敗する" do
    parking.name = 'a' * 31
    parking.valid?
    expect(parking.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "所在地が存在しない場合投稿が失敗する" do
    parking.address = nil
    parking.valid?
    expect(parking.errors[:address]).to include("を入力してください")
  end

  it "所在地が100文字以下の場合投稿できる" do
    parking.address = 'a' * 100
    expect(parking).to be_valid
  end

  it "所在地が101文字以上の場合投稿が失敗する" do
    parking.address = 'a' * 101
    parking.valid?
    expect(parking.errors[:address]).to include("は100文字以内で入力してください")
  end

  it "駐輪料金が存在しない場合投稿が失敗する" do
    parking.fee = nil
    parking.valid?
    expect(parking.errors[:fee]).to include("を入力してください")
  end

  it "駐輪料金が20文字以下の場合投稿できる" do
    parking.fee = 'a' * 20
    expect(parking).to be_valid
  end

  it "駐輪料金が21文字以上の場合投稿が失敗する" do
    parking.fee = 'a' * 21
    parking.valid?
    expect(parking.errors[:fee]).to include("は20文字以内で入力してください")
  end

  it "駐輪台数が存在しない場合投稿が失敗する" do
    parking.capacity = nil
    parking.valid?
    expect(parking.errors[:capacity]).to include("を入力してください")
  end

  it "駐輪台数が20文字以下の場合投稿できる" do
    parking.capacity = 'a' * 20
    expect(parking).to be_valid
  end

  it "駐輪台数が21文字以上の場合投稿が失敗する" do
    parking.capacity = 'a' * 21
    parking.valid?
    expect(parking.errors[:capacity]).to include("は20文字以内で入力してください")
  end

  it "投稿者名が存在しない場合投稿が失敗する" do
    parking.user_id = nil
    parking.valid?
    expect(parking.errors[:user_id]).to include("を入力してください")
  end

  it "備考欄が150文字以下の場合投稿できる" do
    parking.others = 'a' * 150
    expect(parking).to be_valid
  end

  it "備考欄が151文字以上の場合投稿が失敗する" do
    parking.others = 'a' * 151
    parking.valid?
    expect(parking.errors[:others]).to include("は150文字以内で入力してください")
  end

  it '緯度が空欄の場合、投稿が失敗する' do
    parking.latitude = nil
    parking.valid?
    expect(parking.errors[:latitude]).to include("を入力してください")
  end

  it '経度が空欄の場合、投稿が失敗する' do
    parking.longitude = nil
    parking.valid?
    expect(parking.errors[:longitude]).to include("を入力してください")
  end

  it '単位時間が空欄の場合、投稿が失敗する' do
    parking.time = nil
    parking.valid?
    expect(parking.errors[:time]).to include("を入力してください")
  end

  it "単位時間が20文字以下の場合投稿できる" do
    parking.time = 'a' * 20
    expect(parking).to be_valid
  end

  it "駐輪台数が21文字以上の場合投稿が失敗する" do
    parking.time = 'a' * 21
    parking.valid?
    expect(parking.errors[:time]).to include("は20文字以内で入力してください")
  end

   it '１時間当たりの駐輪料金が空欄の場合、投稿が失敗する' do
     parking.price = nil
     parking.valid?
     expect(parking.errors[:price]).to include("を入力してください")
   end
end
