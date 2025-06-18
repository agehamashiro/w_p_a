require 'rails_helper'

RSpec.describe "Dishes", type: :request do
  describe "GET /show" do
    it "returns http success" do
      dish = Dish.create!(
        name: "Test Dish",
        description: "Sample description",
        image_url: "http://example.com/test.jpg"
      )
      get dish_path(dish)
      expect(response).to have_http_status(:success)
    end
  end
end