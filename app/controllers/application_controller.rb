class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  add_breadcrumb 'Home', :root_path

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :page_options

  private

  def page_options
    {page_id: 'default'}
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :uid, :provider, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :uid, :provider, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
