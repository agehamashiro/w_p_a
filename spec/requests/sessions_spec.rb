require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    let(:user) { User.create(email: 'test@example.com', password: 'password', password_confirmation: 'password') }

    it "logs in and redirects" do
      post '/login', params: { email: user.email, password: 'password' }
      expect(response).to have_http_status(:found) # or :redirect if you redirect after login
    end
  end

  describe "DELETE /destroy" do
    it "logs out and redirects" do
      delete '/logout'
      expect(response).to have_http_status(:found) # or :redirect
    end
  end
end
