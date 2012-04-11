class MessagesController < ApplicationController
  
  # POST /conversations/messages
  # POST /conversations/messages.json
  def create
    @message = Message.new params[:message]
    @message.conversation_id = params[:message][:conversation_id]
    @message.user_id = current_user.id
    @conversation = Conversation.find(params[:message][:conversation_id])

    respond_to do |format|
      if @message.save
        @conversation.update_attributes(:last_message_at => Time.now)
        format.html { redirect_to conversation_path(params[:message][:conversation_id]), :notice => 'Message posted successfully.' }
        format.json { render :json => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.json { render :json => @board.errors, :status => :unprocessable_entity }
      end
    end
  end
end