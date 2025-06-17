require 'rails_helper'

RSpec.describe "Dishes", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/dishes/show"
      expect(response).to have_http_status(:success)
    end
  end

end
