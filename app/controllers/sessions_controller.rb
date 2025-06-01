class SessionsController < ApplicationController
  def new
    # ログインフォーム表示
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスかパスワードが違います'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'ログアウトしました'
  end

  def google_auth
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(email: auth.info.email) do |u|
      u.name = auth.info.name
      u.password = SecureRandom.hex(10) # 仮パスワード（使わない）
    end
  
    session[:user_id] = user.id
    redirect_to root_path, notice: 'Googleログインしました'
  end
end