require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/users/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users" do
    it "creates a user and redirects" do
      post "/users", params: {
        user: {
          name: "テストユーザー",
          email: "test@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }

      expect(response).to have_http_status(:found) # 302 リダイレクト
      follow_redirect!
      expect(response.body).to include("登録が完了しました")
    end
  end
end
