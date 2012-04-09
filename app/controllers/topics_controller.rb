class TopicsController < ApplicationController
  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
    @topic = Topic.new
    @post = Post.new
    @boards = Board.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.json
  def create  
    @topic = Topic.new(:name => params[:topic][:name], :last_post_at => Time.now, :board_id => params[:topic][:board_id])
    
    if @topic.save
    @post = Post.new(:content => params[:post][:content], :user_id => current_user.id, :topic_id => @topic.id, :votes => 0)

      if @post.save  
        flash[:notice] = "Successfully created topic."  
        redirect_to "/topics/#{@topic.id}"  
      else  
        redirect :action => 'new'  
      end  
    else  
      render :action => 'new'  
    end
  end
    


  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, :notice => 'Topic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end
end
