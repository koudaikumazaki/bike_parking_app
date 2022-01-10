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
  describe "#associations" do
    it do
      is_expected.to have_many(:favorites).dependent(:destroy)
      is_expected.to belong_to(:user)
    end
  end
  describe "#favorited_by(user)?" do
    let(:parking) { create(:parking) }
    let(:user) { create(:user) }
    subject { parking.favorited_by?(user) }
    context "favarite exists" do
      it { is_expected.to be_falsey }
    end
    context "favarite not exists" do
      before do
        create(:favorite, user_id: user.id, parking_id: parking.id)
      end
      it { is_expected.to be_truthy }
    end
  end
  describe "#self.within_box" do
    let(:distance) { 1 }
    let(:latitude) { '35.6812362' }
    let(:longitude) { '139.7649361' }
    subject { Parking.within_box(distance, latitude, longitude) }
    context "exists parking" do
      let!(:parking) { create(:parking) }
      it { is_expected.to match_array([parking]) }
    end
    context "not exists parking" do
      it { is_expected.to be_empty }
    end
  end
end
