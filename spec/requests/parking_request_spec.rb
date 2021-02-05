require 'rails_helper'

RSpec.describe "Parkings", type: :request do
  describe "GET /index" do
    it "正常にレスポンスを返すこと" do
      get parkings_url
      expect(response).to be_successful
    end
  end

end
