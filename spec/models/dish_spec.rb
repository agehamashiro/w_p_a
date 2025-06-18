require 'rails_helper'

RSpec.describe "Dishes", type: :request do
  describe "GET /show" do
    let(:dish) { Dish.create!(name: "Test Dish", description: "Sample description") }

    it "returns http success" do
      get dish_path(dish)  # これで /dishes/:id に GET リクエスト送信
      expect(response).to have_http_status(:success)
    end
  end
end