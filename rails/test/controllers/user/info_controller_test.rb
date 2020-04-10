require "test_helper"

class User::InfoControllerTest < ActionController::TestCase
  setup do
    sign_in(users(:one))
  end

  test "should get show" do
    get :show
    assert_response :success
  end
end
