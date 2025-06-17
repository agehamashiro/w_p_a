class DishesController < ApplicationController
  before_action :set_dish_map, only: [:show, :ogp]

  def show
    @dish = Dish.find(params[:id])
    # 通常のHTMLレンダリング（OGPを含むheadタグも含めて表示）
    render layout: 'application'
  end

  def ogp
    @dish = Dish.find(params[:id])
    # メタタグ専用のHTMLだけ返す（クローラー向け）
    render layout: false
  end

  def create_from_pairing
    # Gemini APIなどから提案された料理データ（例：params[:dish_data]）を保存
    dish_data = params.require(:dish_data).permit(:name, :description, :image_url)
    dish = Dish.create!(name: dish_data[:name], description: dish_data[:description], image_url: dish_data[:image_url])
    redirect_to dish_path(dish)
  end

  private

  def set_dish_map
    @dish_map = Dish.all.index_by(&:name)
  
    # dish_map に存在しない料理名が来たとき、自動で登録
    requested_names = params[:dishes]&.map { |d| d["料理名"] } || []
    requested_names.each do |name|
      next if @dish_map[name]
  
      new_dish = Dish.create!(name: name, description: "自動生成された説明", image_url: "https://example.com/default.jpg")
      @dish_map[name] = new_dish
    end
  end
end
