require 'rails_helper'

#ログインしないと画面にリンクが表示されないため、ログインしていない場合のテストは行わなかった。
RSpec.describe "Favorites", type: :request do
  before do
    @user = create(:user)
    @parking = create(:parking)
  end

  let(:favorite_params) { attributes_for(:favorite, user_id: @user.id, parking_id: @parking.id) }

  describe "POST /create" do
    before do
      @user.confirm
      sign_in @user
    end
      it "お気に入り機能が成功する" do
      expect {
        post parking_favorites_path(@parking), params: { favorite: favorite_params }, xhr: true
      }.to change { Favorite.count }.from(0).to(1)
    end
  end

  describe "DELETE /destroy" do
    before do
      @user.confirm
      sign_in @user
    end
    it "お気に入り登録を解除する" do
      post parking_favorites_path(@parking), params: { favorite: favorite_params }, xhr: true
      expect {
        delete parking_favorites_path(@parking), params: { favorite: favorite_params }, xhr: true
      }.to change { Favorite.count }.from(1).to(0)
    end
  end
end