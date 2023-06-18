require "test_helper"

class Public::HobbiesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get public_hobbies_show_url
    assert_response :success
  end

  test "should get index" do
    get public_hobbies_index_url
    assert_response :success
  end

  test "should get edit" do
    get public_hobbies_edit_url
    assert_response :success
  end
end
