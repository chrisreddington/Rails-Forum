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
  helper_method :admin_or_owner?
  helper_method :owner?
  
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
  
  def owner?(id)  
    if current_user.id == id  
      return true  
    else  
      return false  
    end  
  end  
  
  def admin_or_owner?(id)
    if (admin_user || owner?(id))
      return true
    else
      return false
    end
  end
  
  def admin_or_owner_required(id)  
    unless admin_or_owner?(id) 
      redirect_to root_url, :alert => "You must either be an admin or the owner to access this page" 
    end  
  end
end
