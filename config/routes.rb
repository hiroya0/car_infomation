Rails.application.routes.draw do
  get 'articles/index'
  get 'articles/show'
  get 'homes/index'
  
  root 'homes#index'
  
  devise_for :users
  resources :articles, only: [:index, :show]
end
