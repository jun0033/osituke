require "test_helper"

class Admin::HobbyCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_hobby_comments_index_url
    assert_response :success
  end
end
