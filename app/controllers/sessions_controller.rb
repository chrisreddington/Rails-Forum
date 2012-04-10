class SessionsController < ApplicationController
  def create
    
    user = User.find_by_email(params[:login])
    if !user
      user = User.find_by_username(params[:login])
    end
    
    if user && user.authenticate(params[:password])
      if user.active
        session[:user_id] = user.id
        redirect_to :back, :notice => "Logged in!"
      else
          redirect_to :back, :alert => "Account is not active"
      end
    else
      redirect_to :back, :alert => "Invalid email or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end