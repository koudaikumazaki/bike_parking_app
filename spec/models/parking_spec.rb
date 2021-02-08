require 'rails_helper'

RSpec.describe Parking, type: :model do
  
  before do
    @parking = create(:parking)
  end

  it "駐輪場名、住所、駐輪料金、駐輪台数、投稿者名が存在すれば投稿できる" do
    @parking.others = nil
    expect(@parking).to be_valid
  end

  it "駐輪場名が存在しない場合投稿が失敗する" do
    @parking.name = nil
    @parking.valid?
    expect(@parking.errors[:name]).to include("を入力してください")
  end

  it "駐輪場名が30文字以下の場合投稿できる" do
    @parking.name = 'a' * 30
    expect(@parking).to be_valid
  end

  it "駐輪場名が31文字以上の場合投稿が失敗する" do
    @parking.name = 'a' * 31
    @parking.valid?
    expect(@parking.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "住所が存在しない場合投稿が失敗する" do
    @parking.address = nil
    @parking.valid?
    expect(@parking.errors[:address]).to include("を入力してください")
  end

  it "住所が100文字以下の場合投稿できる" do
    @parking.address = 'a' * 100
    expect(@parking).to be_valid
  end

  it "住所が101文字以上の場合投稿が失敗する" do
    @parking.address = 'a' * 101
    @parking.valid?
    expect(@parking.errors[:address]).to include("は100文字以内で入力してください")
  end

  it "駐輪料金が存在しない場合投稿が失敗する" do
    @parking.fee = nil
    @parking.valid?
    expect(@parking.errors[:fee]).to include("を入力してください")
  end
  
  it "駐輪料金が20文字以下の場合投稿できる" do
    @parking.fee = 'a' * 20
    expect(@parking).to be_valid
  end

  it "駐輪料金が21文字以上の場合投稿が失敗する" do
    @parking.fee = 'a' * 21
    @parking.valid?
    expect(@parking.errors[:fee]).to include("は20文字以内で入力してください")
  end

  it "駐輪台数が存在しない場合投稿が失敗する" do
    @parking.capacity = nil
    @parking.valid?
    expect(@parking.errors[:capacity]).to include("を入力してください")
  end

  it "駐輪台数が20文字以下の場合投稿できる" do
    @parking.capacity = 'a' * 20
    expect(@parking).to be_valid
  end

  it "駐輪台数が21文字以上の場合投稿が失敗する" do
    @parking.capacity = 'a' * 21
    @parking.valid?
    expect(@parking.errors[:capacity]).to include("は20文字以内で入力してください")
  end

  it "投稿者名が存在しない場合投稿が失敗する" do
    @parking.user_id = nil
    @parking.valid?
    expect(@parking.errors[:user_id]).to include("を入力してください")
  end

  it "備考欄が150文字以下の場合投稿できる" do
    @parking.others = 'a' * 150
    expect(@parking).to be_valid
  end

  it "備考欄が151文字以上の場合投稿が失敗する" do
    @parking.others = 'a' * 151
    @parking.valid?
    expect(@parking.errors[:others]).to include("は150文字以内で入力してください")
  end

end
