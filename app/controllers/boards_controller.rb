class BoardsController < ApplicationController
  
  before_filter :authenticate_admin!, :only => [:index, :new, :create, :update, :edit, :destroy]
  
  # GET /boards
  # GET /boards.json
  def index
    @boards = Board.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    @board = Board.find(params[:id])
    @category = Category.find(@board.category_id)
    @topics = Topic.paginate(:page => params[:page], :conditions => ['board_id = ?', @board.id], :order => 'last_post_at DESC')
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.json
  def new
    @board = Board.new
    @categories = Category.all
    
    if @categories.empty? || @categories.nil?
      redirect_to new_category_path, :alert => "You need to make a category before making a board."
    else
      respond_to do |format|
        format.html # new.html.erb
        format.json { render :json => @board }
      end
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
    @categories = Category.all
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(params[:board])

    respond_to do |format|
      if @board.save
        format.html { redirect_to @board, :notice => 'Board was successfully created.' }
        format.json { render :json => @board, :status => :created, :location => @board }
      else
        format.html { render :action => "new" }
        format.json { render :json => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.json
  def update
    @board = Board.find(params[:id])

    respond_to do |format|
      if @board.update_attributes(params[:board])
        format.html { redirect_to @board, :notice => 'Board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end
end
