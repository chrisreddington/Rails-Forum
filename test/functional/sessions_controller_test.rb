require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    request.env["HTTP_REFERER"] = "http://somewhere.com/"
  end

  test "should accept user" do
    post :create, {:login => @user.username, :password => '123'}
    assert_equal('Logged in!', flash[:notice])
  end
  
  test "should deny user (password)" do
    post :create, {:login => @user.username, :password => 'abc'}
    assert_equal('Invalid email or password', flash[:alert])
  end
  
  test "can login with e-mail" do
    post :create, {:login => @user.email, :password => '123'}
    assert_equal('Logged in!', flash[:notice])
  end
  
  test "should deny user (not activated their account)" do
    post :create, {:login => 'notactive', :password =>'123'}
    assert_equal('Account is not active', flash[:alert])
  end
  
  test "successful logout" do
    get :destroy
    assert_equal('Logged out!', flash[:notice])
  end
  
end