class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # FIXME: まとめられそう。。
  def configure_permitted_parameters
    added_attrs = [:email, :username, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

  def after_sign_in_path_for(_resource)
    if resource.is_a?(AdminUser)
      admin_dashboard_path
    else
      parkings_path
    end
  end

  private

  def sign_in_required
    redirect_to new_user_session_url unless user_signed_in?
  end
end
