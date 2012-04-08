class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def admin_user
    @admin_user ||= @current_user if current_user.admin?
  end
  
  helper_method :admin_user
  helper_method :current_user
  
  def authenticate_user!
    if current_user.nil?
      redirect_to root_url, :alert => "You must first log in to access this page"
    end
  end
  
  def authenticate_admin!
      if admin_user.nil?
        redirect_to root_url, :alert => "You must be an admin access this page"
      end
  end
end
