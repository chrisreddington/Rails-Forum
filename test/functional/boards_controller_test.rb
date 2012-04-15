require 'test_helper'

class BoardsControllerTest < ActionController::TestCase
  
  #######################################
  ###### LOGGED-OUT USER TESTS ##########
  #######################################
  
  setup do
    @one = boards(:one)
    @two = boards(:two)
  end
  
  test "logged out users cannot view list of boards" do
    get :index
    assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged out users can view individual board pages" do
    get :show, :id => @one.id
    (assert_response :success || assert_equal('The information you requested does not exist.', flash[:alert]))
  end
  
  test "logged out user cannot create new board" do
    assert_no_difference('Board.count') do
      put :create, :board => @one.attributes
    end
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged out users cannot view edit board pages" do
    get :edit, :id => @one.id
    assert_redirected_to(root_url)
  end
  
  test "logged out user can not update boards" do
      put :update, :id => @one.id, :board => @one.attributes
      assert_redirected_to(root_url)
  end
  
  test "logged out user can not delete boards" do
      delete :destroy, :id => @one.id
      assert_redirected_to(root_url)
  end
  
  #######################################
  ####### LOGGED-IN USER TESTS ##########
  #######################################
  
  test "logged in user cannot view the boards index" do
    login_as(:user)
    get :index
    assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can view specific board pages" do
    login_as(:user)
    get :show, :id => @one.id
    assert_response :success
  end
  
  test "logged in user cannot create new board" do
    login_as(:user)
      assert_no_difference('Board.count') do
        put :create, :board => @one.attributes
      end
        assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user cannot view board edit pages" do
    login_as(:user)
    get :edit, :id => @one.id
    assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can not update board" do
      login_as(:user)
      put :update, :id => @one.id, :board => @one.attributes
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can not delete board" do
      login_as(:user)
      delete :destroy, :id => @one.id
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  #######################################
  ############ ADMIN TESTS ##############
  #######################################
  
  test "admin can view board list page" do
    login_as(:admin)
    get :index
    assert_response :success
  end
  
  test "admin can view specific board page" do
    login_as(:admin)
    get :show, :id => @one.id
    assert_response :success
  end

  test "admin can create new board" do
    login_as(:admin)
    assert_difference('Board.count') do
      put :create, :id => @one.id, :board => @one.attributes
    end      
      assert_equal('Board was successfully created.', flash[:notice])
  end
  
  test "admin can view board edit pages" do
    login_as(:admin)
    get :edit, :id => @one.id
    assert_response :success
  end
  
  test "admin can update board" do
      login_as(:admin)
      put :update, :id => @one.id, :category => @one.attributes
      assert_redirected_to(@one)
  end
  
  test "admin should delete board" do
      login_as(:admin)
      assert_difference('Board.count', -1) do
        delete :destroy, :id => @one.id
      end
      assert_redirected_to(boards_url)
  end
end
