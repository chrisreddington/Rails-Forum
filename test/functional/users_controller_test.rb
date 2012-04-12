require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  test "should load new user page" do
    get :new
    assert_response :success
  end
  
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
  
  test "logged out users cannot view edit pages" do
    get :edit
    assert_redirected_to(root_url)
  end
  
  test "logged out users cannot view userlist" do
    get :index
    assert_redirected_to(root_url)
  end

  test "logged out users cannot view individual user pages" do
    get :show
    assert_redirected_to(root_url)
  end
end