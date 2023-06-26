require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "should get signup" do
    get signup_path
    assert_response :success
  end

  test "should be redirected to home when signup path is accessed when signed in" do
    sign_user_in_from_tests(@user)

    get signup_path
    assert_redirected_to root_path
  end

  test "should redirect to home when signin is accessed while signed in" do
    sign_user_in_from_tests(@user)

    get signin_path
    assert_redirected_to root_path
  end
end
