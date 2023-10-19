Rails.application.routes.draw do
  get 'articles/index'
  get 'articles/show'
  get 'homes/index'
  
  root 'homes#index'
  
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  
  resources :articles, only: [:index, :show] do
    resources :comments, only: [:create]
  end

  resources :comments, only: [:index, :destroy] 

  resources :bookmarks, only: [:index, :create, :destroy]

end
