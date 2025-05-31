Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  get 'www.winepair.jp', to: redirect('https://winepair.jp')
  get '/mypage', to: 'users#show', as: 'mypage'

  get "up" => "rails/health#show", as: :rails_health_check

  root 'wines#new'
  resources :wines, only: [:new, :create, :show]
end

