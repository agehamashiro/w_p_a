require 'net/http'
require 'json'

class WinesController < ApplicationController
  def new
    @wine = Wine.new
  end
  
  def create
    @wine = Wine.new(wine_params)
    @wine.price_range = params[:wine][:price_range]  # 仮想属性をセット
  
    if @wine.save
      redirect_to wine_path(@wine, price_range: @wine.price_range) # showで使う場合に渡す
    else
      render :new
    end
  end
  
  
  def show
    @wine = Wine.find(params[:id])
    @wine.price_range = params[:price_range] # パラメータで受け取る
    @pairing_suggestion = fetch_pairing_suggestion(@wine)
  end
  
  private
  
  def wine_params
    params.require(:wine).permit(:price, :region, :variety, :preference, :ingredient)
  end
  
  def fetch_pairing_suggestion(wine)
    api_key = ENV['GEMINI_API_KEY']
    return "APIキーが設定されていません" if api_key.nil? || api_key.empty?
  
    url = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{api_key}")
    price_text = case wine.price_range
                 when '500-1000' then '500～1000円'
                 when '1000-2000' then '1000～2000円'
                 when '2000+' then '2000円以上'
                 else '価格指定なし'
                 end
    prompt = <<~PROMPT
      #{wine.price}円の#{wine.region}産、品種#{wine.variety}のワインに合う料理を提案してください。
      料理の好みは「#{wine.preference.presence || '指定なし'}」、使いたい食材は「#{wine.ingredient.presence || '指定なし'}」です。
      料理名と詳しい料理の説明を **JSON 配列のみ** で返してください。料理数は5つ以下。料理名にスペースは使わない
      例:
      [
        { "料理名": "鶏肉のソテー:", "説明": "ハーブやスパイスでシンプルに味付けした鶏もも肉のソテーは、メルローの果実味とよく合います。" },
        { "料理名": "肉の生姜焼き", "説明": "生姜の風味がメルローの風味を引き立てます。" }
      ]
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
  
      # **不要な ```json ``` を削除**
      cleaned_text = suggestion_text.gsub(/```json|```/, "").strip
  
      Rails.logger.info "Cleaned Gemini API Response: #{cleaned_text}"
  
      parsed_suggestion = JSON.parse(cleaned_text)
  
      unless parsed_suggestion.is_a?(Array) && parsed_suggestion.all? { |d| d.is_a?(Hash) && d.key?("料理名") && d.key?("説明") }
        Rails.logger.error "Unexpected response format: #{parsed_suggestion}"
        return ["APIのレスポンスが予期しない形式です"]
      end
  
      # 料理名に対応する画像のパスを設定
      parsed_suggestion.each do |dish|
        # 画像のファイル名を日本語で設定
        image_name = "#{dish["料理名"]}.jpg"
        image_path = Rails.root.join('public', 'images', image_name)
  
        # 画像が存在するか確認して存在すればそのURLを設定
        dish["image_url"] = image_exists?(image_path) ? "/images/#{image_name}" : nil
      end

      parsed_suggestion
    rescue JSON::ParserError => e
      Rails.logger.error "レスポンス解析エラー: #{e.message}"
      ["レスポンス解析エラー: #{e.message}"]
    end
  end

  def image_exists?(image_path)
    File.exist?(image_path)
  end
    
end


