require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#valid" do
    it do
      is_expected.to validate_presence_of(:username)
      is_expected.to validate_presence_of(:email)
      is_expected.to validate_length_of(:username).is_at_most(30)
      is_expected.to validate_length_of(:email).is_at_most(100)
      is_expected.to validate_uniqueness_of(:email).case_insensitive
    end
    it "メールアドレスが正しいフォーマットで入力されていることを確認する" do
      addresses = %w[
        user@foo,com
        user_at_foo.org
        example.user@foo.foo@bar_baz.com
        foo@bar+baz.com
        foo@bar..com
      ]
      addresses.each do |invalid_address|
        expect(build(:user, email: invalid_address)).to be_invalid
      end
    end
  end
  describe "#associations" do
    it do
      is_expected.to have_many(:favorites).dependent(:destroy)
      is_expected.to have_many(:parkings).dependent(:destroy)
      is_expected.to have_many(:favorite_parkings).through(:favorites).source(:parking)
    end
  end
  describe "#self.guest" do
    
  end
end
