Rails.application.routes.draw do

  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/help',  to: 'static_pages#help'

  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  #resources :users も含まれる
  #/users/1/following や /users/1/followers のURLを作成
  #HTTPリクエスト	URL	          アクション	   名前付きルート
  #GET	/users/1/following	following	following_user_path(1)
  #GET	/users/1/followers	followers	followers_user_path(1)
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :microposts
  resources :relationships, only: [:create, :destroy]
  resources :password, only: [:edit, :update]
end
