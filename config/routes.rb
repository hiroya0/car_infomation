Rails.application.routes.draw do
  get 'articles/index'
  get 'homes/index'
  
  root 'homes#index'
  
  devise_for :users
  
end
