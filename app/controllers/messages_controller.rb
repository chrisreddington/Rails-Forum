class MessagesController < ApplicationController
  def new
    @message = Message.new
  end
  
  def create
    #Take a look at how you're setting the conversations id, as it's not taking the appropraite ID.
    @message = Message.new params[:message]
    @message.conversation_id = params[:message][:conversation_id]
    @message.user_id = current_user.id
    @message.save
    @conversation = Conversation.find(params[:message][:conversation_id])
    @conversation.update_attributes(:last_message_at => Time.now)
    redirect_to conversation_path(params[:message][:conversation_id])
    
  end
end