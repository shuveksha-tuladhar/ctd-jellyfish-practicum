class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  include SessionsHelper
  helper_method :current_user

  private
  def require_login
    unless current_user
      redirect_to login_path, alert: "Please log in."
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    unless current_user
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end
end
