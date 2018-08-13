require 'test_helper'

class UseCaseControllerTest < ActionDispatch::IntegrationTest
  test "should get newUser" do
    get use_case_newUser_url
    assert_response :success
  end

end
