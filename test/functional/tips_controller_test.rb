require 'test_helper'

class TipsControllerTest < ActionController::TestCase
  test "should get gamma" do
    get :gamma
    assert_response :success
  end

  test "should get lambda" do
    get :lambda
    assert_response :success
  end

  test "should get eta" do
    get :eta
    assert_response :success
  end

end
