class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound, :with => :rescue_not_found
  before_filter :initialise_variables
  helper_method :initialise_variables
  helper_method :admin_user
  helper_method :current_user
  helper_method :admin_or_owner?
  helper_method :owner?
  helper_method :list_can_access_resource?
  
  def initialise_variables
    if ENV["RAILS_ENV"] != "test"
    #initialise site-wide settings
    @title = Setting.find_by_name('title').value
    @system_email = Setting.find_by_name('system_email').value
    @domain_name = Setting.find_by_name('domain_name').value
  end
  end
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def admin_user
    @admin_user ||= @current_user if current_user && current_user.admin?
  end
  
  def authenticate_user!
    if current_user.nil?
      redirect_to root_url, :alert => "You must first log in to access this page"
    end
  end
  
  def authenticate_admin!
      if admin_user.nil?
        redirect_to root_url, :alert => "You must be an admin to access this page"
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
  
  def list_can_access_resource?(resource)
    if resource.include?(current_user)
      return true
    else
      return false
    end
  end
  
  def certain_users_required(resource)
    unless list_can_access_resource?(resource)
      redirect_to root_url, :alert => "You cannot view this page."
    end
  end
  
  def admin_or_owner_required(id)  
    unless admin_or_owner?(id) 
      redirect_to root_url, :alert => "You must either be an admin or the owner to access this page" 
    end  
  end
end


  def rescue_not_found
    redirect_to  root_url, :alert => "The information you requested does not exist."
  end