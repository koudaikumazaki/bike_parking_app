require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do
  before do
    @user = create(:user)
    @guest_user = create(:user, email: "guest@example.com", password: "fhjdashfuirhagldjfkajlsf")
  end
  
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, username: "") }
  let(:guest_user_params) { attributes_for(:user, email: "guest@example.com", password: "fhjdashfuirhagldjfkajlsf") }
  let(:new_user_params) { attributes_for(:user, username: "after_update") }

  describe "GET /users/sign_up" do
    it "新規登録画面の表示に成功すること" do
      get new_user_registration_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    before do
      ActionMailer::Base.deliveries.clear
    end
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: user_params }
        expect(response.status).to eq 302
      end

      it '認証メールが送信されること' do
        post user_registration_path, params: { user: user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it 'createが成功すること' do
        expect do
          post user_registration_path, params: { user: user_params }
        end.to change(User, :count).by 1
      end

      it 'リダイレクトされること' do
        post user_registration_path, params: { user: user_params }
        expect(response).to redirect_to root_url
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.status).to eq 200
      end

      it '認証メールが送信されないこと' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(ActionMailer::Base.deliveries.size).to eq 0
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: invalid_user_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.body).to include 'エラーが発生したため ユーザー は保存されませんでした。'
      end
    end
  end

  describe "GET /users/sign_in" do
    it "ログイン画面の表示に成功すること" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users/sign_in" do
    context "有効なパラメータの場合" do
    it "ログインに成功すること" do
        post user_session_path, params: { user: user_params }
        expect(response).to have_http_status(200)
      end
    end
    context "無効なパラメータの場合" do
      it "ログインに失敗すること" do
        post user_session_path, params: { user: invalid_user_params }
        expect(response.body).to include 'Eメールまたはパスワードが違います。'
      end
    end
  end

  describe "DELETE /users/sign_out" do
    it "ログアウトに成功すること" do
      @user.confirm
      sign_in @user
      delete destroy_user_session_path
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET #edit' do
    subject { get edit_user_registration_path }
    context 'ログインしている場合' do
      before do
        @user.confirm
        sign_in @user
      end
      it 'リクエストが成功すること' do
        is_expected.to eq 200
      end
    end
    context 'ゲストの場合' do
      it 'リダイレクトされること' do
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH edit' do
    context "ログインユーザーの場合" do
      before do
        @user.confirm
        sign_in @user
      end
      context "値が有効の場合" do
        it "更新が成功する" do
          patch user_registration_path, params: { user: new_user_params }
          # binding.pry
          @user.reload
          expect(@user.username).to eq "after_update"
        end
      end
      context "値が無効の場合" do
        
      end
    end
    context "ゲストユーザーとしてログインしている場合" do
      
    end
    context "ログインしていない場合" do
      
    end
  end

  describe "DELETE /users/registrations#destroy" do
    it "ユーザーの削除に成功すること" do
      @user.confirm
      sign_in @user
      expect {
        delete user_registration_path
      }.to change(User, :count).from(2).to(1)
    end
  end

  describe "POST /users/guest_sign_in" do
    it "ゲストユーザーとしてログインできること" do
      post users_guest_sign_in_path, params: { user: guest_user_params }
      expect(response).to have_http_status(302)
    end
  end
end