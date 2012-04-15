require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  
  #######################################
  ###### LOGGED-OUT USER TESTS ##########
  #######################################
  
  setup do
    @one = categories(:one)
    @two = categories(:two)
  end
  
  test "logged out users cannot view list of categories" do
    get :index
    assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged out users can view individual category pages" do
    get :show, :id => @one.id
    assert_response :success
  end
  
  test "logged out user cannot create new category" do
    assert_no_difference('Category.count') do
      put :create, :category => @one.attributes
    end
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged out users cannot view edit pages" do
    get :edit, :id => @one.id
    assert_redirected_to(root_url)
  end
  
  test "logged out user can not update categories" do
      put :update, :id => @one.id, :category => @one.attributes
      assert_redirected_to(root_url)
  end
  
  test "logged out user can not delete categories" do
      delete :destroy, :id => @one.id
      assert_redirected_to(root_url)
  end
  
  #######################################
  ####### LOGGED-IN USER TESTS ##########
  #######################################
  
  test "logged in user cannot view the categories index" do
    login_as(:user)
    get :index
    assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can view specific category pages" do
    login_as(:user)
    get :show, :id => @one.id
    assert_response :success
  end
  
  test "logged in user cannot create new category" do
    login_as(:user)
      assert_no_difference('Category.count') do
        put :create, :category => @one.attributes
      end
        assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user cannot view category edit pages" do
    login_as(:user)
    get :edit, :id => @one.id
    assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can not updat category" do
      login_as(:user)
      put :update, :id => @one.id, :category => @one.attributes
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  test "logged in user can not delete category" do
      login_as(:user)
      delete :destroy, :id => @one.id
      assert_equal('You must be an admin to access this page', flash[:alert])
  end
  
  #######################################
  ############ ADMIN TESTS ##############
  #######################################
  
  test "admin can view category list page" do
    login_as(:admin)
    get :index
    assert_response :success
  end
  
  test "admin can view specific category pages" do
    login_as(:admin)
    get :show, :id => @one.id
    assert_response :success
  end

  test "admin can create new category" do
    login_as(:admin)
    assert_difference('Category.count') do
      put :create, :id => @one.id, :category => @one.attributes
    end      
      assert_equal('Category was successfully created.', flash[:notice])
  end
  
  test "admin can view category edit pages" do
    login_as(:admin)
    get :edit, :id => @one.id
    assert_response :success
  end
  
  test "admin can update category" do
      login_as(:admin)
      put :update, :id => @one.id, :category => @one.attributes
      assert_redirected_to(@one)
  end
  
  test "admin should delete category" do
      login_as(:admin)
      assert_difference('Category.count', -1) do
        delete :destroy, :id => @one.id
      end
      assert_redirected_to(categories_url)
  end
end
