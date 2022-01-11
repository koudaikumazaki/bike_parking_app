require 'rails_helper'

RSpec.describe Parkings::QueryBuilder, type: :model do
  describe "#search" do
    context "search_point is empty" do
      let(:query_builder) { Parkings::QueryBuilder.new(location: nil, keyword: 'near') }
      subject { query_builder.search }
      let(:parking) { create(:parking) }
      it { is_expected.to be_empty }
    end
    context "keyword is near" do
      let(:query_builder) { Parkings::QueryBuilder.new(location: '東京駅', keyword: 'near') }
      let(:parking) { create(:parking) }
      let(:other_parking) { create(:parking, latitude: '35.80') }
      subject { query_builder.search }
      before do
        query_builder.
      end
      it { is_expected.to match_array([parking, other_parking]) }
    end
    context "keyword is inexpensive" do
      
    end
    context "keyword is capacity" do
      
    end
  end
end
