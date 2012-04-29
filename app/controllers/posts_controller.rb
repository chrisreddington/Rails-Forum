class PostsController < ApplicationController
  
  before_filter :authenticate_user!
  
  # GET /posts
  # GET /posts.json
  # def index
  #  @posts = Post.paginate(:page => params[:page], :order => 'votes, created_at')

  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.json { render :json => @posts }
  #  end
  # end

  # GET /posts/1
  # GET /posts/1.json
  # def show
  #  @post = Post.find(params[:id])

  # respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render :json => @post }
  #  end
  # end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @topic ||= Topic.find_by_id(params[:topic]) 
    @post = Post.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @topic = Topic.find(@post.topic_id)
    admin_or_owner_required(@post.user_id)
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(:content => params[:post][:content], :user_id => current_user.id, :topic_id => params[:post][:topic_id], :votes => 0)
    @topic = Topic.find_by_id(params[:post][:topic_id])
    respond_to do |format|
      if @post.save
        @topic.update_attributes(:last_post_at => Time.now) 
        format.html { redirect_to @topic, :notice => 'Post was successfully created.' }
        format.json { render :json => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    params[:post][:topic_id] = @post.topic_id
    params[:post][:user_id] = @post.user_id
    @topic = Topic.find(@post.topic_id)
    admin_or_owner_required(@post.user_id)

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @topic, :notice => 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    admin_or_owner_required(@post.user_id)
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
end
