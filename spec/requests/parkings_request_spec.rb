require 'rails_helper'

RSpec.describe "Parkings", type: :request do
  before do
    @user = create(:user)
    # associationでリンクしていたはずだが、updateアクションでテストが通らなかったので関連づけを行った。
    @parking = create(:parking, user_id: @user.id)
    @other_user = create(:user)
  end
  
  # before do ~ end を使うとparking_paramsと
  # invalid_parking_paramsが定義できなかったのでletを使った。
  let(:parking_params) { attributes_for(:parking) }
  let(:invalid_parking_params) { attributes_for(:parking, name: nil) }
  let(:new_parking_params) { attributes_for(:parking, name: 'after_update') }

  describe "GET /index" do
    it "正常にレスポンスを返すこと" do
      get parkings_url
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /show" do
    it "正常にレスポンスを返すこと" do
      get parking_url(@parking)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /new" do
    context "ログインユーザーの場合" do
      before do
        @user.confirm
        sign_in @user
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
        @user.confirm
        sign_in @user
      end
      context "有効な属性値の場合" do
        it "投稿が成功する" do
          expect {
            post parkings_url, params: { parking: parking_params }
          }.to change(Parking, :count).from(1).to(2)
        end
        it "トップページにリダイレクトされる" do
          post parkings_url, params: { parking: parking_params}
          expect(response).to redirect_to root_path
        end
      end
      context "無効な属性値の場合" do
        it "投稿が失敗する" do
          expect {
            post parkings_url, params: { parking: invalid_parking_params }
          }.to_not change(Parking, :count)
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
        @user.confirm
        sign_in @user
      end
      it "正常にレスポンスを返すこと" do
        get edit_parking_url(@parking)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "サインイン画面にリダイレクトすること" do
        get edit_parking_url(@parking)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /update" do
    context "投稿者本人の場合" do
      before do
        @user.confirm
        sign_in @user
      end
      context "更新内容が有効な場合" do
        it "投稿が成功する" do
          patch parking_path(@parking), params: { parking: new_parking_params }
          @parking.reload
          expect(@parking.name).to eq "after_update"
        end
        it "トップページにリダイレクトする" do
          patch parking_url(@parking), params: { parking: new_parking_params }
          expect(response).to redirect_to root_path
        end
      end
      context "更新内容が無効の場合" do
        it "投稿が失敗する" do
          patch parking_url(@parking), params: { parking: invalid_parking_params }
        end
        it "編集ページを読み込む" do
          patch parking_url(@parking), params: { parking: invalid_parking_params }
          expect(response).to render_template 'parkings/edit'
        end
      end
    end
    context "投稿者以外の場合" do
      before do
        @other_user.confirm
        sign_in @other_user
      end
      it "投稿が失敗する" do
        patch parking_url(@parking), params: { parking: new_parking_params }
        expect(@parking.name).to eq "parking"
        expect(response).to redirect_to root_path
      end
    end
    context "ログインしていない場合" do
      it "サインイン画面にリダイレクトすること" do
        patch parking_url(@parking), params: { parking: new_parking_params }
        expect(@parking.name).to eq "parking"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE /update" do
    context "ログインしている場合" do
      context "投稿者の場合" do
        before do
          @user.confirm
          sign_in @user
        end
        it "削除に成功する" do
          expect {
            delete parking_url(@parking)
          }.to change(Parking, :count).from(1).to(0)
        end
        it "トップページにリダイレクトする" do
          delete parking_url(@parking)
          expect(response).to redirect_to root_path
        end
      end

      context "投稿者じゃない場合" do
        before do
          @other_user.confirm
          sign_in @other_user
        end
        it "削除に失敗する" do
          expect {
            delete parking_url(@parking)
          }.to_not change(Parking, :count)
        end
        it "トップページにリダイレクトする" do
          delete parking_url(@parking)
          expect(response).to redirect_to root_path
        end
      end
    end
    context "ログインしていない場合" do
      it "削除に失敗する" do
        expect {
          delete parking_url(@parking)
        }.to_not change(Parking, :count)
      end
      it "サインイン画面にリダイレクトする" do
        delete parking_url(@parking)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end