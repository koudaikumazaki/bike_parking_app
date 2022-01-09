require 'rails_helper'

RSpec.describe Parking, type: :model do
  let(:parking) { create(:parking) }

  describe "#valid" do
    it do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:address)
      is_expected.to validate_presence_of(:fee)
      is_expected.to validate_presence_of(:price)
      is_expected.to validate_presence_of(:capacity)
      is_expected.to validate_presence_of(:user_id)
      is_expected.to validate_presence_of(:latitude)
      is_expected.to validate_presence_of(:longitude)
      is_expected.to validate_presence_of(:time)
      is_expected.to validate_length_of(:name).is_at_most(30)
      # is_expected.to validate_length_of(:fee).is_at_most(20)
      # is_expected.to validate_length_of(:price).is_at_most(20)
      is_expected.to validate_length_of(:address).is_at_most(100)
      # is_expected.to validate_length_of(:capacity).is_at_most(20)
      is_expected.to validate_length_of(:others).is_at_most(150)
      # is_expected.to validate_length_of(:time).is_at_most(20)
    end
  end

  it "駐輪料金が20文字以下の場合投稿できる" do
    parking.fee = '1' * 20
    expect(parking).to be_valid
  end

  it "駐輪料金が21文字以上の場合投稿が失敗する" do
    parking.fee = '1' * 21
    parking.valid?
    expect(parking.errors[:fee]).to include("は20文字以内で入力してください")
  end

  it "駐輪台数が20文字以下の場合投稿できる" do
    parking.capacity = '1' * 20
    expect(parking).to be_valid
  end

  it "駐輪台数が21文字以上の場合投稿が失敗する" do
    parking.capacity = '1' * 21
    parking.valid?
    expect(parking.errors[:capacity]).to include("は20文字以内で入力してください")
  end

  it "単位時間が20文字以下の場合投稿できる" do
    parking.time = '1' * 20
    expect(parking).to be_valid
  end

  it "単位時間が21文字以上の場合投稿が失敗する" do
    parking.time = '1' * 21
    parking.valid?
    expect(parking.errors[:time]).to include("は20文字以内で入力してください")
  end

  it "１時間当たりの駐輪料金が20文字以内の場合、投稿が失敗する" do
    parking.time = '1' * 20
    expect(parking).to be_valid
  end

  it "１時間当たりの駐輪料金21文字以上の場合、投稿が失敗する" do
    parking.time = '1' * 21
    parking.valid?
    expect(parking.errors[:time]).to include("は20文字以内で入力してください")
  end
end
