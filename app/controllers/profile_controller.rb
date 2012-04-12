class ProfileController < ApplicationController
  def show
    @user = current_user
    @authentications = current_user.authentications
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_show_path, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "profile#edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @user = current_user
    @user.destroy
    session[:user_id] = nil

    respond_to do |format|
      format.html { redirect_to root_url, :notice => 'Your account was successfully removed.' }
      format.json { head :no_content }
    end
  end
end
