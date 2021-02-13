require 'rails_helper'

RSpec.describe "Parkings", type: :request do

  # parkingに関してはdestroyアクションをテストする前にデータが保存されていないと
  # エラーが出たため、let!とした。
  let(:user) { create(:user) }
  let!(:parking) { create(:parking, user_id: user.id) }
  let(:other_user) { create(:user) }
  let(:parking_params) { attributes_for(:parking) }
  let(:invalid_parking_params) { attributes_for(:parking, name: nil) }
  let(:new_parking_params) { attributes_for(:parking, name: 'after_update') }
  let(:api_new_parking_params) { attributes_for(:parking, latitude: '35.630152', longitude: '139.74044') }

  describe "GET /index" do
    it "正常にレスポンスを返すこと" do
      get parkings_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /show" do
    it "正常にレスポンスを返すこと" do
      get parking_url(parking)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /new" do
    context "ログインユーザーの場合" do
      before do
        user.confirm
        sign_in user
      end
      it "正常にレスポンスを返すこと" do
        get new_parking_url
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "サインイン画面にリダイレクトすること" do
        get new_parking_url
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST /create" do
    context "ログインユーザーの場合" do
      before do
        user.confirm
        sign_in user
      end
      context "有効な属性値の場合" do
        it "投稿が成功する" do
          expect do
            post parkings_url, params: { parking: parking_params }
          end.to change(Parking, :count).from(1).to(2)
        end
        it "トップページにリダイレクトされる" do
          post parkings_url, params: { parking: parking_params }
          expect(response).to redirect_to root_path
        end
      end
      context "無効な属性値の場合" do
        it "投稿が失敗する" do
          expect do
            post parkings_url, params: { parking: invalid_parking_params }
          end.to_not change(Parking, :count)
        end
        it "新規投稿ページを読み込む" do
          post parkings_url, params: { parking: invalid_parking_params }
          expect(response).to have_http_status(200)
        end
      end
    end
    context "ログインしていないユーザーの場合" do
      it "サインイン画面にリダイレクトする" do
        post parkings_url
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET /edit" do
    context "ログインユーザーの場合" do
      before do
        user.confirm
        sign_in user
      end
      it "正常にレスポンスを返すこと" do
        get edit_parking_url(parking)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "サインイン画面にリダイレクトすること" do
        get edit_parking_url(parking)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /update" do
    context "投稿者本人の場合" do
      before do
        user.confirm
        sign_in user
      end
      context "更新内容が有効な場合" do
        it "投稿が成功する" do
          patch parking_path(parking), params: { parking: new_parking_params }
          parking.reload
          expect(parking.name).to eq "after_update"
        end
        it "トップページにリダイレクトする" do
          patch parking_url(parking), params: { parking: new_parking_params }
          expect(response).to redirect_to root_path
        end
      end
      context "更新内容が無効の場合" do
        it "投稿が失敗する" do
          patch parking_url(parking), params: { parking: invalid_parking_params }
        end
        it "編集ページを読み込む" do
          patch parking_url(parking), params: { parking: invalid_parking_params }
          expect(response).to render_template 'parkings/edit'
        end
      end
    end
    context "投稿者以外の場合" do
      before do
        other_user.confirm
        sign_in other_user
      end
      it "投稿が失敗する" do
        patch parking_url(parking), params: { parking: new_parking_params }
        expect(parking.name).to eq "parking"
        expect(response).to redirect_to root_path
      end
    end
    context "ログインしていない場合" do
      it "サインイン画面にリダイレクトすること" do
        patch parking_url(parking), params: { parking: new_parking_params }
        expect(parking.name).to eq "parking"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE /destroy" do
    context "ログインしている場合" do
      context "投稿者の場合" do
        before do
          user.confirm
          sign_in user
        end
        it "削除に成功する" do
          expect do
            delete parking_url(parking)
          end.to change(Parking, :count).from(1).to(0)
        end
        it "トップページにリダイレクトする" do
          delete parking_url(parking)
          expect(response).to redirect_to root_path
        end
      end

      context "投稿者じゃない場合" do
        before do
          other_user.confirm
          sign_in other_user
        end
        it "削除に失敗する" do
          expect do
            delete parking_url(parking)
          end.to_not change(Parking, :count)
        end
        it "トップページにリダイレクトする" do
          delete parking_url(parking)
          expect(response).to redirect_to root_path
        end
      end
    end
    context "ログインしていない場合" do
      it "削除に失敗する" do
        expect do
          delete parking_url(parking)
        end.to_not change(Parking, :count)
      end
      it "サインイン画面にリダイレクトする" do
        delete parking_url(parking)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # 新規追加分
  describe 'GoogleMapAPIのテスト' do
    before do
      user.confirm
      sign_in user
    end
    it '緯度と経度が設定された状態で投稿すると、所在地のカラムが緯度と経度由来の物になる' do
      post parkings_url, params: { parking: parking_params }
      expect(parking.address).to eq '日本、〒100-0005 東京都千代田区丸の内１丁目９'
    end
    it '編集時に緯度と経度を更新すると、所在地も更新される' do
      patch parking_path(parking), params: { parking: api_new_parking_params }
      parking.reload
      expect(parking.address).to eq "日本、〒108-0075 東京都港区港南１丁目９−３６ アレア品川"
    end
  end
end
