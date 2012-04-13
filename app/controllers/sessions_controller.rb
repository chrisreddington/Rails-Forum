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
  
  def auth
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    if authentication
      session[:user_id] = authentication.user_id
      redirect_to root_url, :notice => 'Signed in successfully'
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to profile_show_path => 'Authentication added to your account'
    else
      user = User.new
      user.apply_omniauth(omniauth)
      
      if user.save
        session[:user_id] = user.id
        redirect_to root_url, :notice => 'Signed in successfully'
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_path, :notice => 'Please provide us with a further few details.'
      end
    end
      
 # auth = request.env['omniauth.auth']
  #unless @auth = Authentication.find_from_hash(auth)
    # Create a new user or add an auth to existing user, depending on
    # whether there is already a user signed in.
  #  @auth = Authentication.create_from_hash(auth, current_user)
  #end
  # Log the authorizing user in.
 # session[:user_id] = @auth.user_id
  
 # redirect_to(root_url)
  end
  
  #def auth
 #   render :text => request.env['omniauth.auth'].to_yaml
  #end
  
  def destroy_auth
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to profile_show_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end