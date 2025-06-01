Rails.application.routes.draw do
  # ユーザー登録（新規登録画面表示・登録処理）
  get 'signup', to: 'users#new', as: 'signup'
  resources :users, only: [:new, :create]

  # セッション管理（ログイン画面表示・ログイン処理・ログアウト処理）
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
  
  get '/auth/:provider/callback', to: 'sessions#google_auth'
  get '/auth/failure', to: redirect('/')

  get 'mypage', to: 'users#show', as: 'mypage'
  patch 'mypage', to: 'users#update'

  resources :reviews, only: [:create]

  # ワイン関連
  resources :wines, only: [:new, :create, :show]

  # 提案料理の詳細表示用ルーティングを追加
  resources :suggestions, only: [:show]

  # リダイレクト
  get 'www.winepair.jp', to: redirect('https://winepair.jp')

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # ルートパス
  root 'wines#new'
end
