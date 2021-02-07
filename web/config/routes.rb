Rails.application.routes.draw do
  resources :notes
  resources :books
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'
  get 'authorized', to: 'sessions#page_requires_login'
  post 'close', to: 'sessions#close'
  resources :users, only: [:new, :create]
  root to: 'sessions#welcome'
end
