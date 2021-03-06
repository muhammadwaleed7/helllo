Rails.application.routes.draw do

  root 'staticpage#home'
  get '/login' , to: 'sessions#new'
  post '/login'  ,to: 'sessions#create'
  delete '/logout' , to: 'sessions#destroy'
  get '/home' , to: 'staticpage#home'
  get '/about' , to: 'staticpage#about'
  get '/contact' , to: 'staticpage#contact'
  get '/help' , to: 'staticpage#help'
  get '/signup' , to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end
