require "test_helper"

class WinesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get wines_new_url
    assert_response :success
  end

  test "should get create" do
    get wines_create_url
    assert_response :success
  end

  test "should get show" do
    get wines_show_url
    assert_response :success
  end
end
