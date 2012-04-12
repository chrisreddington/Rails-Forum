class UserConversationsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:index]
  
  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = current_user.conversations.paginate(:page => params[:page], :order => 'last_message_at DESC')
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @conversations }
    end
    
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    
    @conversation = current_user.conversations.find params[:id]
    @message = Message.new
    
    if list_can_access_resource?(@conversation.users)
      @conversation.user_conversations.find_by_user_id(current_user.id).update_attributes(:read => true)
      current_user.conversations
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @conversation }
      end
   else
      redirect_to root_url, :alert => "You cannot view this page."
    end
  end


  # GET /conversations/new
  # GET /conversations/new.json
  def new
    @conversation = current_user.user_conversations.build
    @conversation.build_conversation.messages.build
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @conversation }
    end
  end

  # POST /conversations
  # POST /conversations.json
  def create
    @conversation = UserConversation.new params[:user_conversation]
    @conversation.user = current_user
    @conversation.read = false
    @conversation.conversation.last_message_at = Time.now
    @conversation.conversation.messages.first.user = current_user
    
    
    respond_to do |format|
      if @conversation.save!
        format.html { redirect_to conversation_path(@conversation.conversation), :notice => 'Conversation was successfully created.' }
        format.json { render :json => @conversation, :status => :created, :location => @conversation }
      else
        format.html { render :action => "new" }
        format.json { render :json => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def mark_as_read
    @conversation = UserConversation.find params[:id]
    
    respond_to do |format|
      if @conversation.update_attributes(:read => true)
        format.html { redirect_to conversation_path(@conversation), :notice => 'Conversation has been marked as read' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end

  def mark_as_unread
    @conversation = UserConversation.find params[:id]
    
    respond_to do |format|
      if @conversation.update_attributes(:read => false)
        format.html { redirect_to conversation_path(@conversation), :notice => 'Conversation has been marked as unread' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @conversation.errors, :status => :unprocessable_entity }
      end
    end
  end
end