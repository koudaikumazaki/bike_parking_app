module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :check_guest, only: [:update, :destroy]

    def check_guest
      redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません。' if resource.email == User::GUEST_EMAIL
    end

    def edit
      @parkings = @user.parkings
      @parkings = @parkings.page(params[:page]).per(3)
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
