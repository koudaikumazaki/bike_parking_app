Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'parkings#index'

  resources :parkings, shallow: true do
    resource :favorites, only: [:create, :destroy]
    get :favorites, on: :collection
  end

  get '/users', to: redirect("/users/sign_up")

  # 簡単ログイン用ルーティング
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  get 'search', to: 'parkings#search'

end
