require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:user)
    @notactive = users(:notactive)
    request.env["HTTP_REFERER"] = "http://somewhere.com/"
  end

  test "should accept user" do
    post :create, {:login => @user.username, :password => '123'}
    assert_equal('Logged in!', flash[:notice])
  end
  
  test "should deny user with incorrect password" do
    post :create, {:login => @user.username, :password => 'abc'}
    assert_equal('Invalid email or password', flash[:alert])
  end
  
  test "can login with e-mail" do
    post :create, {:login => @user.email, :password => '123'}
    assert_equal('Logged in!', flash[:notice])
  end
  
  test "should deny users who are not active, by username" do
    post :create, {:login => @notactive.username, :password =>'123'}
    assert_equal('Account is not active', flash[:alert])
  end
  
  test "should deny users who are not active, by email" do
    post :create, {:login => @notactive.email, :password =>'123'}
    assert_equal('Account is not active', flash[:alert])
  end
  
  test "successful logout" do
    login_as(:user)
    get :destroy
    assert_equal('Logged out!', flash[:notice])
  end
  
end