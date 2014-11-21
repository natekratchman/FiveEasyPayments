Rails.application.routes.draw do

  resources :users

  root 'users#show'

  get '/login' => 'sessions#new'
  get '/auth/venmo/callback/' => 'sessions#create'

  get '/logout' => 'sessions#destroy'
  
end
