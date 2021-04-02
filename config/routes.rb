Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'parkings#index'

  resources :parkings, shallow: true do
    resource :favorites, only: [:create, :destroy]
    get :favorites, on: :collection
  end

  get '/users', to: redirect("/users/sign_up")

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  get 'search', to: 'parkings#search'

  resources :contacts, only: [:new, :create]
  post 'contacts/confirm', to: 'contacts#confirm', as: 'confirm'
  post 'contacts/back', to: 'contacts#back', as: 'back'
  get 'done', to: 'contacts#done', as: 'done'
end
