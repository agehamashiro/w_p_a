class DishesController < ApplicationController
  before_action :set_dish_map, only: [ :show, :ogp ]

  def show
    @dish = Dish.find(params[:id])
    render layout: "application"
  end

  def ogp
    @dish = Dish.find(params[:id])
    render layout: false
  end

  def create_from_pairing
    dish_data = params.require(:dish_data).permit(:name, :description, :image_url)
    dish = Dish.create!(name: dish_data[:name], description: dish_data[:description], image_url: dish_data[:image_url])
    redirect_to dish_path(dish)
  end

  private

  def set_dish_map
    @dish_map = Dish.all.index_by(&:name)

    requested_names = params[:dishes]&.map { |d| d["料理名"] } || []

    requested_names.each do |name|
      next if @dish_map[name]

      dish_data = params[:dishes].find { |d| d["料理名"] == name }

      description = dish_data["説明"].presence || "自動生成された説明です。"
      image_url = dish_data["image_url"].presence || "https://example.com/default.jpg"

      new_dish = Dish.create!(
        name: name,
        description: description,
        image_url: image_url
      )

      @dish_map[name] = new_dish
    end
  end
end
