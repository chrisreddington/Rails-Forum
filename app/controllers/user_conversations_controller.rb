class UserConversationsController < ApplicationController

  def index
    @conversations = current_user.user_conversations
  end

  def show
    @conversation = UserConversation.find params[:id]
    @message = Message.new
  end

  def new
  @conversation = current_user.user_conversations.build
  @conversation.build_conversation.messages.build
  end

  def create
    @conversation = UserConversation.new params[:user_conversation]
    @conversation.user = current_user
    @conversation.conversation.messages.first.user = current_user
    @conversation.save!
    redirect_to user_conversation_path(@conversation)
  end

  def mark_as_read
    @conversation = UserConversation.find params[:id]
    @conversation.update_attributes :read => true
    redirect_to user_conversation_path(@conversation)
  end

  def mark_as_unread
    @conversation = UserConversation.find params[:id]
    @conversation.update_attributes :read => false
    redirect_to user_conversation_path(@conversation)
  end
end