Rails.application.routes.draw do
  resources :notes, only: [:new, :create, :show, :update, :export, :edit, :destroy]
  resources :books, only: [:new, :create, :show, :update, :export, :edit, :index, :destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'
  post 'close', to: 'sessions#close'
  resources :users, only: [:new, :create]
  root to: 'sessions#welcome'

  post 'notes/export', to:'notes#export'
  post 'notes/download', to:'notes#download'

  post 'books/export_all', to:'books#export_all'
end
