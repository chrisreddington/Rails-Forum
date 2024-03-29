class UsersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:new, :create, :confirm]  
  before_filter :authenticate_admin!, :only => [:edit, :destroy, :update]

  # GET /users
  # GET /users.json
  def index
    @users =  User.paginate(:page => params[:page], :order => 'username')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
      @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      
      if session[:omniauth]['info']['nickname']
        @user.username = session[:omniauth]['info']['nickname']
      end
      
      
      if session[:omniauth]['info']['email']
        @user.email = session[:omniauth]['info']['email']
      end
      
      if session[:omniauth]['info']['name']
        @name = session[:omniauth]['info']['name'].split(' ')
        @user.firstname = @name.first
        @user.lastname = @name.last
      end
      @user.valid?
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
      @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    
    
    if session[:omniauth]
      @user.password_digest = session[:omniauth]['credentials']['secret']
    end
    
    respond_to do |format|
      if @user.save
        
        if session[:omniauth]
          @user.authentications.create!(:provider => session[:omniauth]['provider'], :uid => session[:omniauth]['uid'])
          session[:omniauth] = nil unless @user.new_record?
        end
        
        # Tell the UserMailer to send a welcome Email after save
        SystemMailer.welcome_email(@user).deliver
        
        format.html { redirect_to root_url, :notice => 'A verification e-mail has been sent.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

      
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  def confirm
    @user = User.find(params[:user_id])
    respond_to do |format|
        if params[:hash] == Digest::SHA1.hexdigest(@user.created_at.to_s + @user.id.to_s) && @user.update_attributes(:active => 1)
          format.html { redirect_to root_url, :notice => 'Your account was authorised successfully.' }
          format.json { head :no_content }
        else
          format.html { redirect_to root_url, :alert => 'Your account could not be authorised. Please contact an admin.' }
          format.json { render :json => @user.errors, :status => :unprocessable_entity }
        end
    end
  end
end