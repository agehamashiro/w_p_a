require 'net/http'
require 'json'

class WinesController < ApplicationController
  def new
    @wine = Wine.new
  end
  
  def create
    @wine = Wine.new(wine_params)
    if @wine.save
      redirect_to wine_path(@wine)
    else
      render :new
    end
  end
  
  def show
    @wine = Wine.find(params[:id])
    @pairing_suggestion = fetch_pairing_suggestion(@wine)
  end
  
  private
  
  def wine_params
    params.require(:wine).permit(:price, :region, :variety)
  end
  
  def fetch_pairing_suggestion(wine)
    api_key = ENV['GEMINI_API_KEY']
    return "APIキーが設定されていません" if api_key.nil? || api_key.empty?

    url = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{api_key}")

    prompt = <<~PROMPT
      #{wine.price}円の#{wine.region}産、品種#{wine.variety}のワインに合う料理を提案してください。
      日本のスーパーで買える食材を使い、家庭で簡単に作れるレシピを考えてください。
      料理名と簡単なレシピの説明を JSON 形式で返してください。
      例:
      {
        "料理名": "和風ステーキ",
        "レシピ": "牛肉を焼き、醤油とみりんで味付け。付け合わせに大根おろしを添える。"
      }
    PROMPT

    request_body = {
      model: "gemini-2.0-flash",
      contents: [{ parts: [{ text: prompt }] }]
    }.to_json

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url, { 'Content-Type' => 'application/json' })
    request.body = request_body

    response = http.request(request)

    begin
      data = JSON.parse(response.body)
      suggestion_text = data.dig('candidates', 0, 'content', 'parts', 0, 'text')
      return suggestion_text || "提案が取得できませんでした"
    rescue JSON::ParserError => e
      return "レスポンス解析エラー: #{e.message}"
    end
  end
end


