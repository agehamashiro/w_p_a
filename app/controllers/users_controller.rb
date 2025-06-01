class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "登録が完了しました。ようこそ！"
    else
      render :new
    end
  end

  def show
    @user = current_user
    @reviews = @user.reviews.includes(:suggestion)
  end
  
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to mypage_path, notice: "情報を更新しました。"
    else
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

