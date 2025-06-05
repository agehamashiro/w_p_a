# spec/system/wine_pairings_spec.rb
require 'rails_helper'

RSpec.describe "WinePairings", type: :system do
  before do
    # Gemini APIのスタブ（実通信を防ぐ）
    http_double = instance_double(Net::HTTP)
    allow(Net::HTTP).to receive(:new).and_return(http_double)
    allow(http_double).to receive(:use_ssl=).with(true)
    allow(http_double).to receive(:request).and_return(mock_response)
  end

  let(:mock_response) do
    instance_double(Net::HTTPResponse, body: {
      candidates: [ {
        content: {
          parts: [ {
            text: <<~JSON
              [
                { "料理名": "チキンソテー", "説明": "ジューシーな鶏肉と酸味のあるワインがよく合います。" }
              ]
            JSON
          } ]
        }
      } ]
    }.to_json)
  end

  it "ユーザーがワイン情報を入力し、提案を確認できる" do
    visit new_wine_path

    select "1000～2000円", from: "ワインの価格帯"
    fill_in "産地", with: "フランス"
    fill_in "品種", with: "ピノ・ノワール"
    fill_in "料理の好み", with: "さっぱり"
    fill_in "使いたい食材", with: "鶏肉"
    click_button "料理を提案"

    expect(page).to have_content("おすすめの料理")
    expect(page).not_to have_content("不明なエラーが発生しました")
    expect(page).to have_text(/鶏肉|ワイン|料理|ジューシー/)
  end
end
