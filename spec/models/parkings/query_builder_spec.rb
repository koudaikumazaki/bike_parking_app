require 'rails_helper'

RSpec.describe Parkings::QueryBuilder, type: :model do
  describe "#search" do
    context "search_point is empty" do
      let(:query_builder) { Parkings::QueryBuilder.new(location: nil, keyword: 'near') }
      subject { query_builder.search }
      let(:parking) { create(:parking) }
      it { is_expected.to be_empty }
    end
  end
end
