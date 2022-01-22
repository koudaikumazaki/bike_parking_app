require "rails_helper"

RSpec.describe ::Parkings::Form, type: :model do
  let(:form) { ::Parkings::Form.new(parking, current_user.id, attributes) }
  let(:parking) { ::Parking.new }
  let(:current_user) { create(:user) }
  let(:attributes) { attributes_for(:parking_form).merge(customize_attribute) }
  let(:customize_attribute) { {} }
  describe "#valid?" do
    subject { form }
    it do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:address)
      is_expected.to validate_presence_of(:fee)
      is_expected.to validate_presence_of(:fee_per_hour)
      is_expected.to validate_presence_of(:capacity)
      is_expected.to validate_presence_of(:user_id)
      is_expected.to validate_presence_of(:latitude)
      is_expected.to validate_presence_of(:longitude)
      is_expected.to validate_presence_of(:time)
      is_expected.to validate_length_of(:name).is_at_most(30)
      is_expected.to validate_numericality_of(:fee).only_integer
      is_expected.to validate_numericality_of(:fee_per_hour).only_integer
      is_expected.to validate_numericality_of(:capacity).only_integer
      is_expected.to validate_numericality_of(:time).only_integer
      is_expected.to validate_length_of(:address).is_at_most(100)
      is_expected.to validate_length_of(:others).is_at_most(150)
    end
  end
  describe "#save" do
    subject { form.save }
    context "when sucess create" do
      it { is_expected.to be_truthy }
      it { expect { subject }.to change { ::Parking.count }.by(1) }
    end
    context "when sucess update" do
      let!(:parking) { create(:parking) }
      let(:customize_attribute) { { name: "update_parking" } }
      it { is_expected.to be_truthy }
      it do
        expect { subject }.to_not change { ::Parking.count }
        expect(parking.reload.name).to eq("update_parking")
      end
    end
    context "when occurs expect" do
      before do
        allow(parking).to receive(:assign_attributes)
        allow(parking).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
      end
      it { is_expected.to be_falsey }
      it do
        expect { subject }.to_not change { ::Parking.count }
      end
    end
  end
end