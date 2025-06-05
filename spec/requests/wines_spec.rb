require 'rails_helper'

RSpec.describe "Wines", type: :request do
  describe "GET /wines/:id" do
    let(:wine) do
      Wine.create(
        price: 1500,
        region: "フランス",
        variety: "ピノ・ノワール",
        preference: "さっぱり",
        ingredient: "鶏肉"
      )
    end

    let(:mock_response_body) do
      {
        candidates: [
          {
            content: {
              parts: [
                {
                  text: <<~JSON
                    [
                      { "料理名": "チキンソテー", "説明": "ジューシーな鶏肉と酸味のあるワインがよく合います。" }
                    ]
                  JSON
                }
              ]
            }
          }
        ]
      }.to_json
    end

    before do
      mock_http = instance_double(Net::HTTP)
      mock_response = instance_double(Net::HTTPResponse, body: mock_response_body)
      allow(Net::HTTP).to receive(:new).and_return(mock_http)
      allow(mock_http).to receive(:use_ssl=)
      allow(mock_http).to receive(:request).and_return(mock_response)
    end

    it "Gemini APIの結果を表示する" do
      get wine_path(wine, price_range: "1000～2000円")
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("おすすめの料理")
      expect(response.body).not_to include("不明なエラーが発生しました")
      expect(response.body).to match(/料理名|ジューシー|ワインがよく合います/)
    end
  end
end

