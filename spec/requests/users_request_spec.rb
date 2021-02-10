require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do

  # guest_user用のfactory作ろうとしたが、uninitialized constant GuestUserと出てきたのでやめた。
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, username: "") }
  let(:guest_user) { create(:user, email: "guest@example.com", password: "fhjdashfuirhagldjfkajlsf") }
  let(:guest_user_params) { attributes_for(:user, email: "guest@example.com", password: "fhjdashfuirhagldjfkajlsf") }
  let(:new_user_params) { attributes_for(:user, username: "after_update", current_password: 'password') }
  let(:invalid_new_user_params) { attributes_for(:user, username: nil, current_password: 'password') }
  let(:new_guest_user_params) do
    attributes_for(:user, username: "after_update", email: "guest@example.com", password: "fhjdashfuirhagldjfkajlsf",
                          current_password: "fhjdashfuirhagldjfkajlsf")
  end

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
      user.confirm
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET #edit' do
    subject { get edit_user_registration_path }
    context 'ログインしている場合' do
      before do
        user.confirm
        sign_in user
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
        user.confirm
        sign_in user
      end
      context "値が有効の場合" do
        it "更新が成功する" do
          patch user_registration_path, params: { user: new_user_params }
          user.reload
          expect(user.username).to eq "after_update"
        end
      end
      context "値が無効の場合" do
        it "更新が失敗する" do
          patch user_registration_path, params: { user: invalid_new_user_params }
          user.reload
          expect(user.username).to eq "test_user"
        end
        it "編集画面を読み込む" do
          patch user_registration_path, params: { user: invalid_new_user_params }
          user.reload
          expect(response).to render_template 'devise/registrations/edit'
        end
      end
    end
    context "ゲストユーザーとしてログインしている場合" do
      before do
        guest_user.confirm
        sign_in guest_user
      end
      it "編集が失敗する" do
        patch user_registration_path, params: { user: new_guest_user_params }
        guest_user.reload
        expect(user.username).to eq "test_user"
      end
      it "トップページにリダイレクトされる" do
        patch user_registration_path, params: { user: new_guest_user_params }
        guest_user.reload
        expect(response).to redirect_to root_path
      end
    end
    context "ログインしていない場合" do
      it "サインイン画面にリダイレクトされる" do
        patch user_registration_path, params: { user: new_user_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE /users/registrations#destroy" do
    it "ユーザーの削除に成功すること" do
      user.confirm
      sign_in user
      expect do
        delete user_registration_path
      end.to change(User, :count).from(1).to(0)
    end
  end

  describe "POST /users/guest_sign_in" do
    it "ゲストユーザーとしてログインできること" do
      post users_guest_sign_in_path, params: { user: guest_user_params }
      expect(response).to have_http_status(302)
    end
  end
end
