require 'test_helper'

class PredictionControllerTest < ActionController::TestCase
  test "should get parameter" do
    get :parameter
    assert_response :success
  end

end
