require "test_helper"

class Public::HobbyCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_hobby_comments_index_url
    assert_response :success
  end
end
