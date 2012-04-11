class MessagesController < ApplicationController
  include ApplicationHelper
  def index
    
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @message = Message.new params[:message]
    @message.user_id = current_user.id
    @message.save
    redirect_to root_url
    
  end
end