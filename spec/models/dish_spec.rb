require 'rails_helper'

RSpec.describe "Dishes", type: :request do
  describe "GET /show" do
    it "returns http success" do
      dish = Dish.create!(name: "Test Dish", ...)
      get dish_path(dish)
      expect(response).to have_http_status(:success)
    end
  end
end