class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_back fallback_location: root_path, notice: "評価を投稿しました。"
    else
      redirect_back fallback_location: root_path, alert: "評価の投稿に失敗しました。"
    end
  end

  private

  def review_params
    params.require(:review).permit(:suggestion_id, :dish_name, :rating, :comment)
  end
end
