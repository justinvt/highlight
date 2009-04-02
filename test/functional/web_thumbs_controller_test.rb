require 'test_helper'

class WebThumbsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:web_thumbs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create web_thumb" do
    assert_difference('WebThumb.count') do
      post :create, :web_thumb => { }
    end

    assert_redirected_to web_thumb_path(assigns(:web_thumb))
  end

  test "should show web_thumb" do
    get :show, :id => web_thumbs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => web_thumbs(:one).to_param
    assert_response :success
  end

  test "should update web_thumb" do
    put :update, :id => web_thumbs(:one).to_param, :web_thumb => { }
    assert_redirected_to web_thumb_path(assigns(:web_thumb))
  end

  test "should destroy web_thumb" do
    assert_difference('WebThumb.count', -1) do
      delete :destroy, :id => web_thumbs(:one).to_param
    end

    assert_redirected_to web_thumbs_path
  end
end
