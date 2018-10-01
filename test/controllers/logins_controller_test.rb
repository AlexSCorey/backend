require 'test_helper'

class LoginsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get logins_create_url
    assert_response :success
  end

end
