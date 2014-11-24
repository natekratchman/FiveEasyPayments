Rails.application.routes.draw do

  resources :users

  root 'users#show'

  get '/login' => 'sessions#new'
  get '/auth/venmo/callback/' => 'sessions#create'

  ## TESTING
  get '/authenticate' => 'sessions#create'
  ###

  get '/logout' => 'sessions#destroy'

  get '/:error' => 'users#error'
  
end
