require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  setup do
    @user = users(:user)
    @notactive = users(:notactive)
    @admin = users(:admin)
  end
  
  test "should load new user page" do
    get :new
    assert_response :success
  end
  
  #######################################
  ########### SIGNUP TESTS ##############
  #######################################
  
  test "should create new user" do
    assert_difference('User.count') do
      User.create!(:email => 'test@test.com', :password => 'foobar', :password_confirmation => 'foobar', :username => 'Bob')
    end
  end
  
  test "should fail due to mismatching password" do
    user = User.new(:email => 'test@test.com', :password => 'foobar', :password_confirmation => 'foobar2', :username => 'Bob')
    assert user.invalid?
  end
  
  test "should fail due to lack of username" do
    user = User.new(:email => 'test@test.com', :password => 'foobar', :password_confirmation => 'foobar', :username => '')
    assert user.invalid?
  end
  
  test "should fail due to lack of email" do
    user = User.new(:email => '', :password => 'foobar', :password_confirmation => 'foobar', :username => 'bob')
    assert user.invalid?
  end

  test "should fail due to improper e-mail" do
    user = User.new(:email => 'blah', :password => 'foobar', :password_confirmation => 'foobar', :username => 'bob')
    assert user.invalid?
  end
  
  #######################################
  ###### LOGGED-OUT USER TESTS ##########
  #######################################
  
  test "logged out users cannot view userlist" do
    get :index
    assert_redirected_to(root_url)
  end
  
  test "logged out users cannot view specific user pages" do
    get :show, :id => @user.id
    assert_redirected_to(root_url)
  end
  
  test "logged out users cannot view edit pages" do
    get :edit, :id => @user.id
    assert_redirected_to(root_url)
  end
  
  test "logged out user can not updateuser" do
      put :update, :id => @admin.id, :user => @admin.attributes
      assert_redirected_to(root_url)
  end
  
  test "logged out user can not delete user" do
      delete :destroy, :id => @user.id
      assert_redirected_to(root_url)
  end
  
  #######################################
  ####### LOGGED-IN USER TESTS ##########
  #######################################
  
  test "logged in user can view user list page" do
    login_as(:user)
    get :index
    assert_response :success
  end
  
  test "logged in user can view specific user pages" do
    login_as(:user)
    get :show, :id => @user.id
    assert_response :success
  end
  
  test "logged in user cannot view edit pages" do
    login_as(:user)
    get :edit, :id => @user.id
    assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can not updateuser" do
      login_as(:user)
      put :update, :id => @admin.id, :user => @admin.attributes
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can not delete user" do
      login_as(:user)
      delete :destroy, :id => @user.id
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  #######################################
  ############ ADMIN TESTS ##############
  #######################################
  
  test "admin can view user list page" do
    login_as(:admin)
    get :index
    assert_response :success
  end
  
  test "admin can view specific user pages" do
    login_as(:admin)
    get :show, :id => @user.id
    assert_response :success
  end
  
  test "admin can view edit pages" do
    login_as(:admin)
    get :edit, :id => @user.id
    assert_response :success
  end
  
  test "admin can update user" do
      login_as(:admin)
      put :update, :id => @user.id, :user => @user.attributes
      assert_redirected_to(@user)
  end
  
  test "admin should delete user" do
      login_as(:admin)
      assert_difference('User.count', -1) do
        delete :destroy, :id => @user.id
      end
      assert_redirected_to(users_url)
  end
end