require 'net/http'
require 'json'

class WinesController < ApplicationController
  def new
    @wine = Wine.new
  end

  def create
    @wine = Wine.new(wine_params)
    @wine.price_range = params[:wine][:price_range]

    if @wine.save
      redirect_to wine_path(@wine, price_range: @wine.price_range)
    else
      render :new
    end
  end

  def show
    @wine = Wine.find(params[:id])
    @wine.price_range = params[:price_range]
  
    if @wine.suggestions.any?
      @suggestion = @wine.suggestions.last
      @pairing_suggestion = JSON.parse(@suggestion.data)
      @error_message = nil
    else
      result = fetch_pairing_suggestion(@wine)
  
      if result.is_a?(Hash) && result[:error].present?
        @error_message = result[:error]
        @pairing_suggestion = nil
      else
        @pairing_suggestion = result
        @error_message = nil
  
        first_dish = result.first
        if first_dish.is_a?(Hash)
          @suggestion = Suggestion.create(
            wine: @wine,
            dish_name: first_dish["料理名"],
            ingredients: first_dish["食材"] || "",
            data: result.to_json
          )
        else
          Rails.logger.error("想定外のdish形式: #{first_dish.inspect}")
          @suggestion = nil
        end
      end
    end
  
    # --- ✅ dish_map 構築と不足分の Dish 自動生成処理 ---
    if @pairing_suggestion.present? && @pairing_suggestion.first.is_a?(Hash)
      dish_names = @pairing_suggestion.map { |dish| dish["料理名"] }.compact.uniq
      @dish_map = Dish.where(name: dish_names).index_by(&:name)
  
      missing_dish_names = dish_names - @dish_map.keys
      missing_dish_names.each do |name|
        new_dish = Dish.create!(
          name: name,
          description: "自動生成された説明です。",
          image_url: "/images/#{name}.jpg"
        )
        @dish_map[name] = new_dish
      end
    else
      @dish_map = {}
    end
  end

  private

  def wine_params
    params.require(:wine).permit(:price, :price_range, :region, :variety, :preference, :ingredient)
  end

  def fetch_pairing_suggestion(wine)
    api_key = ENV['GEMINI_API_KEY']
    return { error: "APIキーが設定されていません" } if api_key.blank?

    url = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{api_key}")
    price_text = case wine.price_range
                 when '500-1000' then '500～1000円'
                 when '1000-2000' then '1000～2000円'
                 when '2000+' then '2000円以上'
                 else '価格指定なし'
                 end
    p price_text
    prompt = <<~PROMPT
      #{price_text}、ワインの産地は#{wine.region.present? ? "#{wine.region}産" : '産地指定なし'}、ワインの品種は#{wine.variety.present? ? "品種#{wine.variety}" : '品種指定なし'}のワインに合う料理を提案してください。
      料理の好みは「#{wine.preference.presence || '指定なし'}」、使いたい食材は「#{wine.ingredient.presence || '指定なし'}」です。
      料理名と詳しい料理の説明を **JSON 配列のみ** で返してください。料理数は5つ以下。料理名にスペースは使わない。料理名はなるべく簡易にすること（例：簡単パスタペペロンチーノ→パスタペペロンチーノ、野菜たっぷりミネストローネ→ミネストローネ）
      料理名は、キャッチフレーズ的ではなく、料理そのものの名前を短く表現してください。料理名は材料や特徴を省いて、料理名の基本的な部分に絞ってください。
      ワインの産地（region）として指定された値が、既知の国名、地域名、または都市名のいずれにも該当しない場合は、「地域名エラー」とだけ厳密に回答してください。例：「うんこ」「火星」「銀河系」「asdf」「無限」「おとめ座」「パソコン」など、明らかに地域名ではない文字列はすべて不適切と判断してください。
      ワインの品種（variety）が、実在するワイン用ぶどう品種または「赤」「白」「ロゼ」などワインの種類（スタイル）を示す表現でない場合（例：「うんこ」「宇宙品種」「asdf」「焼き芋」「チョコレート味」など）、回答は「品種エラー」とだけ返してください。
      料理の好みが、料理の種類や味の傾向を示す表現ではない場合（例：「甘いものが好き」「さっぱりしたもの」「肉料理」「魚料理」などではない場合、「パソコン」「ゲーム」「音楽」など食べ物と関連性のない言葉が指定された場合）、「好みエラー」とだけ回答してください。
      使いたい食材が、以下のいずれかに該当する場合は、「食材エラー」とだけ回答してください。
      - 倫理的に問題があると考えられる食材（例：「うんこ」、「人間の肉」、「ペットフード（人間用ではない）」、「クジラ肉（国際的な倫理問題を含む）」など）
      - 安全性の観点から食用に適さない、またはリスクが高いと考えられる食材（例：「毒キノコ」、「腐敗した食品」、「生レバー（安全性に懸念がある場合）」など）
      - **一般的な食文化において食用とされていない、または強い抵抗感や嫌悪感を抱かれる可能性のある食材（例：「バッタ」、「イナゴの佃煮」、「セミの幼虫」、「犬肉」、「鳥の脳」、「ゴカイ（釣りエサ系）」、「アリ」など、地域による食文化の違いが大きいものや、多くの人が昆虫全般に対して抱く抵抗感を含む）**
      - 強い不快感を引き起こす可能性のある食材（見た目、匂い、食感などが一般的ではない、または極端なもの：「魚の目玉」、「シュールストレミング」、「サナギ（蚕など）」、「ナマコ」、「ウニの内臓（精巣/卵巣）」、「バロット（孵化途中のアヒルの卵）」、「豚の鼻や耳（見た目が直接的なもの）」、「カエルの脚」、「ドリアン（強い匂い）」、「発酵魚（くさやなど、強い発酵臭）」、「チーズのうじ虫入り（カース・マルツゥ）」など）
      例:
      [
        { "料理名": "鶏肉のソテー:", "説明": "ハーブやスパイスでシンプルに味付けした鶏もも肉のソテーは、メルローの果実味とよく合います。" },
        { "料理名": "肉の生姜焼き", "説明": "生姜の風味がメルローの風味を引き立てます。" }
      ]
    PROMPT
    p prompt

    request_body = {
      model: "gemini-2.0-flash",
      contents: [{ parts: [{ text: prompt }] }]
    }.to_json

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url, { 'Content-Type' => 'application/json' })
    request.body = request_body

    response = http.request(request)
    body_text = response.body.force_encoding('UTF-8')
    Rails.logger.info "🔹Raw Gemini API Response: #{body_text}"

    data = JSON.parse(body_text)
    suggestion_text = data.dig('candidates', 0, 'content', 'parts', 0, 'text')&.strip

    return { error: suggestion_text } if ["地域名エラー", "品種エラー", "好みエラー", "食材エラー"].include?(suggestion_text)

    cleaned_text = suggestion_text.gsub(/```json|```/, "").strip
    parsed_suggestion = JSON.parse(cleaned_text)

    unless parsed_suggestion.is_a?(Array) &&
           parsed_suggestion.all? { |d| d.is_a?(Hash) && d.key?("料理名") && d.key?("説明") }
      return { error: "APIのレスポンスが予期しない形式です" }
    end

    parsed_suggestion.each do |dish|
      image_name = "#{dish["料理名"]}.jpg"
      image_path = Rails.root.join('public', 'images', image_name)
      dish["image_url"] = image_exists?(image_path) ? "/images/#{image_name}" : nil
    end

    parsed_suggestion
  rescue JSON::ParserError => e
    Rails.logger.error "レスポンス解析エラー: #{e.message}"
    { error: "レスポンス解析エラー: #{e.message}" }
  end

  def image_exists?(image_path)
    File.exist?(image_path)
  end
end
