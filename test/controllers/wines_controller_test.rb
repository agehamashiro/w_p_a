require "test_helper"

class WinesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_wine_url
    assert_response :success
  end

  test "should get create" do
    post wines_url, params: {
      wine: {
        price: 1500,
        region: "フランス",
        variety: "ピノ・ノワール",
        preference: "さっぱり",
        ingredient: "鶏肉"
      }
    }
    assert_response :redirect
  end

  test "should get show" do
    wine = Wine.create(
      price: 1500,
      region: "フランス",
      variety: "ピノ・ノワール",
      preference: "さっぱり",
      ingredient: "鶏肉"
    )
    get wine_url(wine)
    assert_response :success
  end
end