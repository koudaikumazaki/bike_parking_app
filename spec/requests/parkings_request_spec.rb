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
  let(:unapproval_parking_params) { attributes_for(:parking, approval: nil) }
  
  describe "GET /index" do
    it "正常にレスポンスを返すこと" do
      get parkings_url
      expect(response).to have_http_status(200)
      expect(response.body).to include '駐輪場一覧'
    end
  end

  describe "GET /show" do
    context 'ユーザー本人の投稿の場合、かつ投稿が承認されていない場合' do
      before do
        user.confirm
        sign_in user
      end
      it '正常にレスポンスを返すこと' do
        parking.approval = nil
        get parking_url(parking)
        expect(response).to have_http_status(200)
      end
    end
    context '投稿者と閲覧者が違うユーザーの場合' do
      before do
        other_user.confirm
        sign_in other_user
      end
      context '投稿が承認されている場合' do
        it '正常にレスポンスを返すこと' do
          get parking_url(parking)
          expect(response).to have_http_status(200)
        end
      end
      context '投稿が承認されていない場合' do
        it 'ホーム画面にリダイレクトされること' do
          parking.update(approval: nil)
          get parking_url(parking)
          expect(response).to have_http_status(302)
        end
      end
    end
    context 'ログインしていない場合' do
      context '投稿が承認されている場合' do
        it '正常にレスポンスを返すこと' do
          get parking_url(parking)
          expect(response).to have_http_status(200)
        end
      end
      context '投稿が承認されていない場合' do
        it 'ホーム画面にリダイレクトされること' do
          # DBの値を変更するため、updateが必要。
          parking.update(approval: nil)
          get parking_url(parking)
          expect(response).to have_http_status(302)
        end
      end
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

  describe 'GET /search' do
    context 'ログインしている場合' do
      before do
        user.confirm
        sign_in user
      end
      context '検索フォームに文字が入っている場合' do
        context '検索に引っ掛かった場合' do
          it '検索結果が表示される' do
            # @parkingがnilだと怒られた。ただ、しっかりテストは通っているので問題ない？
            allow(@parkings).to receive(:search).and_return(parking)
            get search_path, params: { location: '東京駅'}
            expect(response).to have_http_status(200)
            expect(response.body).to include '検索結果が見つかりました。'
          end
        end
        context '検索に引っ掛からなかった場合' do
          it '検索結果はなかったと表示される' do
            allow(@parkings).to receive(:search).and_return("")
            get search_path, params: { location: '北海道' }
            expect(response).to have_http_status(200)
            expect(response.body).to include '検索結果は見つかりませんでした。'
          end
        end
      end
      context '検索フォームに文字が入っていない場合' do
        it 'ホーム画面にリダイレクトされる' do
          allow(@parkings).to receive(:search).and_return("")
          get search_path
          expect(response).to redirect_to root_path
        end
      end
    end
    context 'ログインしていない場合' do
      it 'サインイン画面にリダイレクトされる' do
        get search_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
