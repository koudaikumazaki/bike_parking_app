class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: [:update, :destroy]

  def check_guest
    redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません。' if resource.email == User::GUEST_EMAIL
  end

  # protected

  # def update_resource(resource, params)
  #   resource.update_without_password(params)
  # end
end
