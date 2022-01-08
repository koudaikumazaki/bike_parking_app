module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :check_guest, only: [:update, :destroy]

    def check_guest
      redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません。' if resource.email == ENV['GUEST_EMAIL']
    end

  end
end
