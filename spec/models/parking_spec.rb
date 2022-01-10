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
      is_expected.to validate_numericality_of(:fee).only_integer
      is_expected.to validate_numericality_of(:price).only_integer
      is_expected.to validate_numericality_of(:capacity).only_integer
      is_expected.to validate_numericality_of(:time).only_integer
      is_expected.to validate_length_of(:address).is_at_most(100)
      is_expected.to validate_length_of(:others).is_at_most(150)
    end
  end
  describe "#favorited_by(user)?" do
    context "favarite exists" do
    end
    context "favarite not exists" do
    end
  end
  describe "#self.within_box" do
  end
end
