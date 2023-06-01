require "test_helper"

class Admin::HobbiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_hobbies_index_url
    assert_response :success
  end
end
